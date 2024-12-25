// ignore_for_file: constant_identifier_names

import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_animate/flutter_animate.dart';

enum CaptureFormat {
  BMP24,
  BMP8,
  PNG,
  JPEG,
  TIFF;

  String get string {
    switch (this) {
      case CaptureFormat.BMP24:
        return 'BMP24';
      case CaptureFormat.BMP8:
        return 'BMP8';
      case CaptureFormat.PNG:
        return 'PNG';
      case CaptureFormat.JPEG:
        return 'JPEG';
      case CaptureFormat.TIFF:
        return 'TIFF';
    }
  }
}

extension SwitchBool on bool {
  String get stringSwitch {
    return this ? 'ON' : 'OFF';
  }
}

class OscilloscopeApiProvider {
  Socket? _socket;
  bool _isConnected = false;
  final String ip;
  final int port;

  OscilloscopeApiProvider({
    required this.ip,
    required this.port,
  });

  bool get isConnected => _isConnected;
  Socket get socket {
    if (_socket == null || !_isConnected) throw Exception('Not connected to oscilloscope');

    return _socket!;
  }

  Future<void> connect() async {
    if (_isConnected) return;

    _socket = await Socket.connect(ip, port, timeout: 60.seconds);
    _isConnected = true;
  }

  Future<void> disconnect() async {
    if (!_isConnected) return;

    await _socket!.close();
    _socket = null;
    _isConnected = false;
  }

  Future<Uint8List> capture({
    bool color = true,
    bool invert = false,
    CaptureFormat format = CaptureFormat.PNG,
  }) async {
    if (!_isConnected) throw Exception('Not connected to oscilloscope');

    socket.write(':DISP:DATA? ${color.stringSwitch},${invert.stringSwitch},${format.string}\n');
    final data = await socket.first;
    return data;
  }

  void setChannel(
    int channel, {
    bool state = true,
    int? probeScale,
    double? voltsPerDiv,
    double? offset,
  }) {
    if (!_isConnected) throw Exception('Not connected to oscilloscope');

    socket.write(':CHAN$channel:DISP ${state.stringSwitch}\n');
    if (!state) return;
    if (probeScale != null) socket.write(':CHAN$channel:PROB $probeScale\n');
    if (voltsPerDiv != null) socket.write(':CHAN$channel:SCAL ${voltsPerDiv.toStringAsFixed(1)}\n');
    if (offset != null) socket.write(':CHAN$channel:OFFS ${offset.toStringAsFixed(1)}\n');
  }

  void setTimebase({
    double timePerDiv = 0.001,
  }) {
    if (!_isConnected) throw Exception('Not connected to oscilloscope');

    socket.write(':TIM:MAIN:SCAL ${timePerDiv.toStringAsFixed(3)}\n');
  }
}
