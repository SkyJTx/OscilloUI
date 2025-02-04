import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oscillo_ui/component/errors/error_base.dart';
import 'package:oscillo_ui/constant/oscilloscope.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_api_provider.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_video_command.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oscillo_ui/repo/ui/ui_repo.dart';

class OscilloscopeRepo {

  static final OscilloscopeRepo _instance = OscilloscopeRepo._internal();

  factory OscilloscopeRepo() => _instance;

  OscilloscopeRepo._internal();

  OscilloscopeApiProvider? _apiProvider;

  StreamController<ImageByteWithTimestamp>? _videoStreamController;

  Stream<ImageByteWithTimestamp>? _videoStream;

  Isolate? _videoIsolate;

  ReceivePort? _receivePort;

  SendPort? _sendPort;

  OscilloscopeApiProvider get apiProvider {
    if (_apiProvider == null) {
      throw Exception('OscilloscopeApiProvider is not initialized');
    }
    return _apiProvider!;
  }

  StreamController<ImageByteWithTimestamp> get videoStreamController {
    if (_videoStreamController == null) {
      throw Exception('Video Stream is not initialized');
    }
    return _videoStreamController!;
  }

  Stream<ImageByteWithTimestamp> get videoStream {
    _videoStream ??= videoStreamController.stream.asBroadcastStream();
    return _videoStream!;
  }

  Isolate get videoIsolate {
    if (_videoIsolate == null) {
      throw Exception('Video Isolate is not initialized');
    }
    return _videoIsolate!;
  }

  ReceivePort get receivePort {
    if (_receivePort == null) {
      throw Exception('Receive Port is not initialized');
    }
    return _receivePort!;
  }

  SendPort get sendPort {
    if (_sendPort == null) {
      throw Exception('Send Port is not initialized');
    }
    return _sendPort!;
  }

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> connect(
    String host,
    int port,
  ) async {
    _apiProvider = OscilloscopeApiProvider(
      ip: host,
      port: port,
    );
    await apiProvider.connect();

    _videoStreamController = StreamController<ImageByteWithTimestamp>.broadcast();
    _videoStream = videoStreamController.stream.asBroadcastStream();

    _receivePort = ReceivePort();
    receivePort.listen((message) {
      log('Received message (Main Thread) at ${DateTime.now()}');
      if (message is SendPort) {
        _sendPort = message;
        sendPort.send({
          'ip': apiProvider.ip,
          'port': apiProvider.port.toString(),
        });
      } else if (message is Map<String, String>) {
        if (message.containsKey('timestamp') && message.containsKey('image')) {
          final image = Uint8List.fromList(message['image']!.codeUnits);
          final timestamp = DateTime.parse(message['timestamp']!);
          videoStreamController.add((
            timestamp: timestamp,
            image: image,
          ));
        }
      } else if (message == OscilloscopeVideoCommandType.ready.command) {
        sendPort.send(OscilloscopeVideoCommandType.start.command);
        log('Send start command');
      }
    });

    _videoIsolate = await Isolate.spawn<SendPort>(
      _videoIsolateEntryPoint,
      receivePort.sendPort,
      debugName: 'OscilloscopeVideoIsolate',
    );

    _isConnected = true;
  }

  static Future<void> _videoIsolateEntryPoint(SendPort port) async {
    late final OscilloscopeApiProvider apiProvider;
    final frameTime = (1/60).milliseconds;
    bool isCapturing = false;
    bool isStopped = false;
    Completer<void> initCompleter = Completer();

    final receivePort = ReceivePort();
    receivePort.listen((msg) async {
      log('Received message (Video Isolate) at ${DateTime.now()}');
      if (msg is Map<String, String>) {
        if (!msg.containsKey('ip') || !msg.containsKey('port')) {
          throw Exception('Invalid message');
        }
        final ip = msg['ip']!;
        final port = msg['port']!;
        apiProvider = OscilloscopeApiProvider(
          ip: ip,
          port: int.parse(port),
        );
        await apiProvider.connect();
        log('Connected to oscilloscope');
        initCompleter.complete();
      } else if (msg == OscilloscopeVideoCommandType.start.command) {
        log('Start capturing');
        isCapturing = true;
      } else if (msg == OscilloscopeVideoCommandType.resume.command) {
        isCapturing = true;
      } else if (msg == OscilloscopeVideoCommandType.pause.command) {
        isCapturing = false;
      } else if (msg == OscilloscopeVideoCommandType.stop.command) {
        isCapturing = false;
        isStopped = true;
      }
    });

    port.send(receivePort.sendPort);
    await initCompleter.future;
    log('Video isolate is ready');
    port.send(OscilloscopeVideoCommandType.ready.command);

    late DateTime startTime;
    while (!isStopped) {
      startTime = DateTime.now();
      if (isCapturing) {
        log('Capturing image');
        final data = await apiProvider.capture();
        port.send({
          'timestamp': DateTime.now().toIso8601String(),
          'image': String.fromCharCodes(data),
        });
      }
      final waitTime = frameTime - DateTime.now().difference(startTime);
      await Future.delayed(waitTime > Duration.zero ? waitTime : Duration.zero);
    }

    await apiProvider.disconnect();

    receivePort.close();
  }

  Future<void> sendVideoCommand(OscilloscopeVideoCommandType command) async {
    sendPort.send(command.command);
    final msg = await receivePort.first as OscilloscopeVideoCommandType;
    if (msg.command != command.command) {
      throw Exception('Invalid response');
    }
  }

  Future<void> disconnect() async {
    sendPort.send(OscilloscopeVideoCommandType.stop.command);
    videoIsolate.kill(priority: Isolate.immediate);
    receivePort.close();
    await videoStreamController.close();
    await videoStream.drain();
    await apiProvider.disconnect();

    _apiProvider = null;
    _videoStreamController = null;
    _videoStream = null;
    _videoIsolate = null;
    _receivePort = null;
    _sendPort = null;

    _isConnected = false;
  }

  Future<void> capture({String? fileName}) async {
    
    final data = await apiProvider.capture();
    final name = fileName ?? 'capture_${DateTime.now().millisecondsSinceEpoch}';
    
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final savePath = await SettingsRepo().imageSavePath.value;
      final path = '$savePath/$name.png';
      final file = await File(path).create(recursive: true);
      await file.writeAsBytes(data);
    } else {
      throw UnsupportedPlatformError();
    }
  }
}
