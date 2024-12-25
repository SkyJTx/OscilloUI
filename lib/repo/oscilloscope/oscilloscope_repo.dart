import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_api_provider.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_video_command.dart';

class OscilloscopeRepo {
  static final OscilloscopeRepo _instance = OscilloscopeRepo._internal();

  factory OscilloscopeRepo() => _instance;

  OscilloscopeRepo._internal();

  OscilloscopeApiProvider? _apiProvider;

  StreamController<Uint8List>? _videoStreamController;

  Isolate? _videoIsolate;

  ReceivePort? _receivePort;

  SendPort? _sendPort;

  OscilloscopeApiProvider get apiProvider {
    if (_apiProvider == null) {
      throw Exception('OscilloscopeApiProvider is not initialized');
    }
    return _apiProvider!;
  }

  StreamController<Uint8List> get videoStreamController {
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

    _videoStreamController = StreamController<Uint8List>.broadcast();

    _receivePort = ReceivePort();
    receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        sendPort.send(apiProvider);
      } else if (message is Uint8List) {
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
      } else if (msg is OscilloscopeVideoCommandPause || msg is OscilloscopeVideoCommandStop) {
        isCapturing = false;
      }
    });

    while (true) {
      if (!isCapturing) continue;
      final data = await apiProvider.capture();
      port.send(data);
    }
  }

  void sendVideoCommand(OscilloscopeVideoCommand command) {
    sendPort.send(command);
  }

  Future<void> disconnect() async {
    videoIsolate.kill(priority: Isolate.immediate);
    receivePort.close();
    videoStreamController.close();
    await apiProvider.disconnect();

    _apiProvider = null;
    _videoStreamController = null;
    _videoIsolate = null;
    _receivePort = null;
    _sendPort = null;
  }
}
