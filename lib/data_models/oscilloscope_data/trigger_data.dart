import 'package:equatable/equatable.dart';
import 'package:oscillo_ui/constant/oscilloscope.dart';

class TriggerData extends Equatable {
  final Channel channel;
  final EdgeType edge;
  final double level;

  const TriggerData({
    required this.channel,
    required this.edge,
    required this.level,
  });

  TriggerData copyWith({
    Channel? channel,
    EdgeType? edge,
    double? level,
  }) {
    return TriggerData(
      channel: channel ?? this.channel,
      edge: edge ?? this.edge,
      level: level ?? this.level,
    );
  }

  @override
  List<Object?> get props => [
        channel,
        edge,
        level,
      ];
}
