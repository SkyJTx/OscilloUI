import 'package:equatable/equatable.dart';
import 'package:oscillo_ui/constant/oscilloscope.dart';

class ChannelData extends Equatable {
  final Channel channel;
  final bool state;
  final int probeScale;
  final double voltsPerDiv;
  final double offset;
  final Coupling coupling;

  const ChannelData({
    required this.channel,
    required this.state,
    required this.probeScale,
    required this.voltsPerDiv,
    required this.offset,
    required this.coupling,
  });

  ChannelData copyWith({
    Channel? channel,
    bool? state,
    int? probeScale,
    double? voltsPerDiv,
    double? offset,
    Coupling? coupling,
  }) {
    return ChannelData(
      channel: channel ?? this.channel,
      state: state ?? this.state,
      probeScale: probeScale ?? this.probeScale,
      voltsPerDiv: voltsPerDiv ?? this.voltsPerDiv,
      offset: offset ?? this.offset,
      coupling: coupling ?? this.coupling,
    );
  }

  @override
  List<Object?> get props => [
        channel,
        state,
        probeScale,
        voltsPerDiv,
        offset,
        coupling,
      ];
}