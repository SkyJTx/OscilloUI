enum OscilloscopeVideoCommandType {
  ready,
  start,
  pause,
  resume,
  stop;

  String get command {
    switch (this) {
      case OscilloscopeVideoCommandType.ready:
        return 'ready';
      case OscilloscopeVideoCommandType.start:
        return 'start';
      case OscilloscopeVideoCommandType.pause:
        return 'pause';
      case OscilloscopeVideoCommandType.resume:
        return 'resume';
      case OscilloscopeVideoCommandType.stop:
        return 'stop';
    }
  }
}
