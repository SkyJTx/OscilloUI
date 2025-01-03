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

  bool get isConnected => apiProvider.isConnected;

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
        sendPort.send(apiProvider);
      } else if (message is ImageByteWithTimestamp) {
        videoStreamController.add(message);
      }
    });

    _videoIsolate = await Isolate.spawn(
      _videoIsolateEntryPoint,
      receivePort.sendPort,
      debugName: 'OscilloscopeVideoIsolate',
    );
  }

  Future<void> _videoIsolateEntryPoint(SendPort port) async {
    late final OscilloscopeApiProvider apiProvider;
    bool isCapturing = false;
    bool isStopped = false;

    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    final message = await receivePort.first;

    if (message is OscilloscopeApiProvider) {
      apiProvider = message;
    } else {
      throw Exception('Invalid message');
    }

    receivePort.listen((msg) async {
      if (msg is OscilloscopeVideoCommandStart || msg is OscilloscopeVideoCommandResume) {
        isCapturing = true;
      } else if (msg is OscilloscopeVideoCommandPause) {
        isCapturing = false;
      } else if (msg is OscilloscopeVideoCommandStop) {
        isCapturing = false;
        isStopped = true;
      }

      port.send(msg);
    });

    while (!isStopped) {
      if (!isCapturing) continue;
      final data = await apiProvider.capture();
      port.send((
        timestamp: DateTime.now(),
        image: data,
      ));
    }

    receivePort.close();
  }

  Future<void> sendVideoCommand(OscilloscopeVideoCommand command) async {
    sendPort.send(command);
    final msg = await receivePort.first;
    if (msg.runtimeType != command.runtimeType) {
      throw Exception('Invalid response');
    }
  }

  Future<void> disconnect() async {
    sendPort.send(OscilloscopeVideoCommandStop());
    videoIsolate.kill(priority: Isolate.immediate);
    receivePort.close();
    await videoStreamController.close();
    await apiProvider.disconnect();

    _apiProvider = null;
    _videoStreamController = null;
    _videoIsolate = null;
    _receivePort = null;
    _sendPort = null;
  }

  Future<Uint8List> saveCapture() async {
    try {
      sendVideoCommand(OscilloscopeVideoCommandPause());

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
          name: 'capture_${DateTime.now().toIso8601String()}.png',
          album: _imageAlbum,
        );
      } else {
        throw Exception('Saving image is not supported on this platform');
      }

      return image;
    } catch (e) {
      rethrow;
    } finally {
      sendVideoCommand(OscilloscopeVideoCommandResume());
    }
  }
}
