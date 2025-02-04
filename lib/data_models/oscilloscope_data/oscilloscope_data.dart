import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import 'channel_data.dart';
import 'trigger_data.dart';

class OscilloscopeData extends Equatable {
  final bool isConnected;
  final String ip;
  final int port;
  final List<({DateTime timestamp, Uint8List image})> videoFrames;
  final List<ChannelData> channels;
  final double timePerDiv;
  final TriggerData trigger;

  const OscilloscopeData({
    required this.isConnected,
    required this.ip,
    required this.port,
    this.videoFrames = const <({DateTime timestamp, Uint8List image})>[],
    required this.channels,
    required this.timePerDiv,
    required this.trigger,
  });

  OscilloscopeData copyWith({
    bool? isConnected,
    String? ip,
    int? port,
    List<({DateTime timestamp, Uint8List image})>? videoFrames,
    List<ChannelData>? channels,
    double? timePerDiv,
    TriggerData? trigger,
  }) {
    return OscilloscopeData(
      isConnected: isConnected ?? this.isConnected,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      videoFrames: videoFrames ?? this.videoFrames,
      channels: channels ?? this.channels,
      timePerDiv: timePerDiv ?? this.timePerDiv,
      trigger: trigger ?? this.trigger,
    );
  }

  @override
  List<Object?> get props => [
        isConnected,
        ip,
        port,
        videoFrames,
        channels,
        timePerDiv,
        trigger,
      ];
}