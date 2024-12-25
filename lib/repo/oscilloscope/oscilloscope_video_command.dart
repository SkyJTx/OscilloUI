import 'package:equatable/equatable.dart';

abstract class OscilloscopeVideoCommand extends Equatable {
  final String command;
  final String? description;

  const OscilloscopeVideoCommand({
    required this.command,
    this.description,
  });

  @override
  List<Object?> get props => [command, description];
}

class OscilloscopeVideoCommandStart extends OscilloscopeVideoCommand {
  const OscilloscopeVideoCommandStart()
      : super(
          command: 'start',
          description: 'Start the video stream',
        );
}

class OscilloscopeVideoCommandPause extends OscilloscopeVideoCommand {
  const OscilloscopeVideoCommandPause()
      : super(
          command: 'pause',
          description: 'Pause the video stream',
        );
}

class OscilloscopeVideoCommandResume extends OscilloscopeVideoCommand {
  const OscilloscopeVideoCommandResume()
      : super(
          command: 'resume',
          description: 'Resume the video stream',
        );
}

class OscilloscopeVideoCommandStop extends OscilloscopeVideoCommand {
  const OscilloscopeVideoCommandStop()
      : super(
          command: 'stop',
          description: 'Stop the video stream',
        );
}
