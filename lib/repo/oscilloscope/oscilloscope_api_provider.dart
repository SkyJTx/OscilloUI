import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:oscillo_ui/component/task.dart';
import 'package:oscillo_ui/constant/oscilloscope.dart';
import 'package:oscillo_ui/data_models/oscilloscope_data/channel_data.dart';
import 'package:oscillo_ui/data_models/oscilloscope_data/oscilloscope_data.dart';
import 'package:oscillo_ui/data_models/oscilloscope_data/trigger_data.dart';

class OscilloscopeApiProvider {
  Socket? _socket;
  Completer<bool> _connectedCompleter = Completer<bool>();
  final String ip;
  final int port;

  OscilloscopeApiProvider({
    required this.ip,
    required this.port,
  });

  static Future<OscilloscopeApiProvider> create({
    required String ip,
    required int port,
  }) async {
    final provider = OscilloscopeApiProvider(ip: ip, port: port);
    await provider.connect();
    return provider;
  }

  static Future<void> task({
    required String ip,
    required int port,
    required FutureOr<void> Function(OscilloscopeApiProvider provider) callback,
  }) async {
    return Task.runWithArgs(
      func: (args) {
        final ip = args[0] as String;
        final port = args[1] as int;
        final callback = args[2] as FutureOr<void> Function(OscilloscopeApiProvider provider);
        return OscilloscopeApiProvider.create(ip: ip, port: port).then(callback);
      },
      arguments: [ip, port, callback],
    );
  }

  bool get isConnected {
    return _connectedCompleter.isCompleted;
  }

  Future<bool> get connected {
    return _connectedCompleter.future;
  }

  Socket get socket {
    if (_socket == null || !isConnected) throw Exception('Not connected to oscilloscope');
    return _socket!;
  }

  Future<void> connect() async {
    if (isConnected) return;

    _socket = await Socket.connect(ip, port, timeout: 60.seconds);

    _connectedCompleter.complete(true);
  }

  Future<void> disconnect() async {
    if (!isConnected) return;
    await _socket!.close();
    _socket = null;

    _connectedCompleter = Completer<bool>();
  }

  Future<Uint8List> capture({
    bool color = true,
    bool invert = false,
    CaptureFormat format = CaptureFormat.PNG,
  }) async {
    final result =
        await run(':DISP:DATA? ${color.stringSwitch},${invert.stringSwitch},${format.string}');
    return result.sublist(11);
  }

  Future<OscilloscopeData> getAll() async {
    final isConnected = this.isConnected;
    final ip = this.ip;
    final port = this.port;
    final videoFrames = <({Uint8List image, DateTime timestamp})>[];
    final channels = [
      for (final channel in Channel.values)
        ChannelData(
          channel: channel,
          state: await getChannelData<bool>(channel, ChannelEnum.state),
          probeScale: await getChannelData<int>(channel, ChannelEnum.probeScale),
          voltsPerDiv: await getChannelData<double>(channel, ChannelEnum.voltsPerDiv),
          offset: await getChannelData<double>(channel, ChannelEnum.offset),
          coupling: await getChannelData<Coupling>(channel, ChannelEnum.coupling),
        ),
    ];
    final timePerDiv = await getTimebase();
    final triggerChannel = await getTriggerChannel();
    final triggerEdgeType = await getTriggerEdgeType();
    final triggerLevel = await getTriggerLevel();

    return OscilloscopeData(
      isConnected: isConnected,
      ip: ip,
      port: port,
      videoFrames: videoFrames,
      channels: channels,
      timePerDiv: timePerDiv,
      trigger: TriggerData(
        channel: triggerChannel,
        edge: triggerEdgeType,
        level: triggerLevel,
      ),
    );
  }

  Future<T> getChannelData<T>(Channel channel, ChannelEnum data) async {
    final result = await run(':CHAN${channel.number}:${data.string}?');
    return data.deserialize<T>(String.fromCharCodes(result));
  }

  Future<double> getTimebase() async {
    final result = await run(':TIM:MAIN:SCAL?');
    return Data.timePerDiv.deserialize<double>(String.fromCharCodes(result));
  }

  Future<Channel> getTriggerChannel() async {
    final result = await run(':TRIG:EDGE:SOUR?');
    return Data.channel.deserialize<Channel>(String.fromCharCodes(result));
  }

  Future<EdgeType> getTriggerEdgeType() async {
    final result = await run(':TRIG:EDGE:SLOP?');
    return Data.triggerEdgeType.deserialize<EdgeType>(String.fromCharCodes(result));
  }

  Future<double> getTriggerLevel() async {
    final result = await run(':TRIG:EDGE:LEV?');
    return Data.triggerLevel.deserialize<double>(String.fromCharCodes(result));
  }

  Future<void> setMode(Mode mode) async {
    await run(':${mode.string}');
  }

  Future<void> setChannel(
    Channel channel, {
    bool state = true,
    int? probeScale,
    double? voltsPerDiv,
    double? offset,
    Coupling? coupling,
  }) async {
    await run(':CHAN${channel.number}:DISP ${state.stringSwitch}');
    if (!state) return;

    if (probeScale != null) {
      await run(':CHAN${channel.number}:PROB $probeScale');
    }

    if (voltsPerDiv != null) {
      await run(':CHAN${channel.number}:SCAL ${voltsPerDiv.toStringAsFixed(1)}');
    }

    if (offset != null) {
      await run(':CHAN${channel.number}:OFFS ${offset.toStringAsFixed(1)}');
    }

    if (coupling != null) {
      await run(':CHAN${channel.number}:COUP ${coupling.string}');
    }
  }

  Future<void> setTimebase({
    double timePerDiv = 0.001,
  }) async {
    final tpd =
        timePerDiv < 0 ? timePerDiv.toStringAsExponential(1) : timePerDiv.toStringAsFixed(1);
    await run(':TIM:MAIN:SCAL $tpd');
  }

  Future<void> setTrigger(
    Channel channel, {
    EdgeType? edge = EdgeType.POS,
    double? level,
  }) async {
    await run(':TRIG:MODE EDGE');
    await run(':TRIG:EDGE:SOUR CHAN${channel.number}');

    if (edge != null) {
      await run(':TRIG:EDGE:SLOP ${edge.string}');
    }

    if (level != null) {
      await run(':TRIG:EDGE:LEV $level');
    }
  }

  Future<Uint8List> run(
    String command, {
    bool isWriteMode = true,
    Duration interWaitingTime = const Duration(milliseconds: 500),
  }) async {
    final completer = Completer<Uint8List>();
    if (!isConnected) throw Exception('Not connected to oscilloscope');

    socket.writeln(command);

    BytesBuilder respData = BytesBuilder();
    Timer? timer;
    final sub = socket.listen((data) {
      respData.add(data);
      timer?.cancel();
      timer = Timer(interWaitingTime, () {
        final respBytes = respData.toBytes();
        final stringBytes = String.fromCharCodes(respBytes);
        final newLineFilteredStringBytes = stringBytes.replaceAll('\n', '');
        final stringBytesCodeUnits = newLineFilteredStringBytes.codeUnits;
        final data = Uint8List.fromList(stringBytesCodeUnits);
        completer.complete(data);
      });
    });

    return await completer.future.whenComplete(() async {
      timer?.cancel();
      await sub.cancel();
      if (isWriteMode) {
        await socket.flush();
      }
    });
  }
}
