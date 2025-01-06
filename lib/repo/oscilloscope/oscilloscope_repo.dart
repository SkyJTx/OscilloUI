import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_api_provider.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_video_command.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';

typedef ImageByteWithTimestamp = ({
  DateTime timestamp,
  Uint8List image,
});

class OscilloscopeRepo {
  static final String _imageAlbum = 'Oscilloscope';

  static final OscilloscopeRepo _instance = OscilloscopeRepo._internal();

  factory OscilloscopeRepo() => _instance;

  OscilloscopeRepo._internal();

  OscilloscopeApiProvider? _apiProvider;

  StreamController<ImageByteWithTimestamp>? _videoStreamController;

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

    _receivePort = ReceivePort();
    receivePort.listen((message) {
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
      }
    });

    _videoIsolate = await Isolate.spawn(
      _videoIsolateEntryPoint,
      receivePort.sendPort,
      debugName: 'OscilloscopeVideoIsolate',
    );

    _isConnected = true;
  }

  Future<void> _videoIsolateEntryPoint(SendPort port) async {
    late final OscilloscopeApiProvider apiProvider;
    bool isCapturing = false;
    bool isStopped = false;

    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    final message = await receivePort.first;

    if (message is Map<String, String>) {
      if (!message.containsKey('ip') || !message.containsKey('port')) {
        throw Exception('Invalid message');
      }
      final ip = message['ip']!;
      final port = message['port']!;
      apiProvider = OscilloscopeApiProvider(
        ip: ip,
        port: int.parse(port),
      );
      await apiProvider.connect();
    } else {
      throw Exception('Invalid message');
    }

    receivePort.listen((msg) async {
      if (msg == OscilloscopeVideoCommandType.start.command ||
          msg == OscilloscopeVideoCommandType.resume.command) {
        isCapturing = true;
      } else if (msg == OscilloscopeVideoCommandType.pause.command) {
        isCapturing = false;
      } else if (msg == OscilloscopeVideoCommandType.stop.command) {
        isCapturing = false;
        isStopped = true;
      }

      port.send(msg);
    });

    while (!isStopped) {
      if (!isCapturing) continue;
      final data = await apiProvider.capture();
      port.send({
        'timestamp': DateTime.now().toIso8601String(),
        'image': String.fromCharCodes(data),
      });
    }

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
    await apiProvider.disconnect();

    _apiProvider = null;
    _videoStreamController = null;
    _videoIsolate = null;
    _receivePort = null;
    _sendPort = null;

    _isConnected = false;
  }

  Future<Uint8List> saveCapture() async {
    try {
      await sendVideoCommand(OscilloscopeVideoCommandType.pause);

      final image = await apiProvider.capture();
      final pathRepo = SettingsRepo().imageSavePath;
      if (image.isEmpty) {
        throw Exception('Failed to capture image');
      }

      if (await pathRepo.isEnabled) {
        final folderPath = await pathRepo.value;
        final path = '$folderPath/capture_${DateTime.now().toIso8601String()}.png';
        final file = File(path);
        await file.writeAsBytes(image);
      } else if (Platform.isAndroid || Platform.isIOS) {
        if (!await Gal.requestAccess(toAlbum: true)) {
          throw Exception('Permission denied');
        }
        await Gal.putImageBytes(
          image,
          name: 'capture_${DateTime.now().toIso8601String()}',
          album: _imageAlbum,
        );
      } else {
        throw Exception('Saving image is not supported on this platform');
      }

      return image;
    } catch (e) {
      rethrow;
    } finally {
      await sendVideoCommand(OscilloscopeVideoCommandType.resume);
    }
  }
}
