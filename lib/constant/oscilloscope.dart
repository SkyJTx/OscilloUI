// ignore_for_file: constant_identifier_names

import 'dart:typed_data';

typedef ImageByteWithTimestamp = ({
  DateTime timestamp,
  Uint8List image,
});

enum Data {
  timePerDiv,
  channel,
  triggerEdgeType,
  triggerLevel,
  ;

  String get command {
    switch (this) {
      case Data.timePerDiv:
        return 'TIME';
      case Data.channel:
        return 'TRIG:EDGE:SOUR CHAN';
      case Data.triggerEdgeType:
        return 'TRIG:EDGE:SLOP';
      case Data.triggerLevel:
        return 'TRIG:EDGE:LEV';
    }
  }

  T deserialize<T>(String value) {
    switch (this) {
      case Data.timePerDiv:
        return double.parse(value) as T;
      case Data.channel:
        return Channel.values.firstWhere((e) => e.string == value) as T;
      case Data.triggerEdgeType:
        return EdgeType.values.firstWhere((e) => e.string == value) as T;
      case Data.triggerLevel:
        return double.parse(value) as T;
    }
  }
}

enum Channel {
  CH1,
  CH2,
  CH3,
  CH4;

  int get number {
    switch (this) {
      case Channel.CH1:
        return 1;
      case Channel.CH2:
        return 2;
      case Channel.CH3:
        return 3;
      case Channel.CH4:
        return 4;
    }
  }

  @override
  String toString() {
    return string;
  }

  String get string {
    return 'CHAN$number';
  }
}

enum ChannelEnum {
  state,
  probeScale,
  voltsPerDiv,
  offset,
  coupling,
  ;

  String get string {
    switch (this) {
      case ChannelEnum.state:
        return 'DISP';
      case ChannelEnum.probeScale:
        return 'PROB';
      case ChannelEnum.voltsPerDiv:
        return 'SCAL';
      case ChannelEnum.offset:
        return 'OFFS';
      case ChannelEnum.coupling:
        return 'COUP';
    }
  }

  T deserialize<T>(String value) {
    switch (this) {
      case ChannelEnum.state:
        return value == 'ON' ? true as T : false as T;
      case ChannelEnum.probeScale:
        return double.parse(value).toInt() as T;
      case ChannelEnum.voltsPerDiv:
        return double.parse(value) as T;
      case ChannelEnum.offset:
        return double.parse(value) as T;
      case ChannelEnum.coupling:
        return Coupling.values.firstWhere((e) {
          return e.string == value;
        }) as T;
    }
  }
}

enum Mode {
  RUN,
  STOP,
  SINGLE;

  String get string {
    switch (this) {
      case Mode.RUN:
        return 'RUN';
      case Mode.STOP:
        return 'STOP';
      case Mode.SINGLE:
        return 'SING';
    }
  }
}

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

enum Coupling {
  AC,
  DC,
  GND;

  String get string {
    switch (this) {
      case Coupling.AC:
        return 'AC';
      case Coupling.DC:
        return 'DC';
      case Coupling.GND:
        return 'GND';
    }
  }
}

enum EdgeType {
  NEG,
  POS,
  RFAL;

  String get string {
    switch (this) {
      case EdgeType.NEG:
        return 'NEG';
      case EdgeType.POS:
        return 'POS';
      case EdgeType.RFAL:
        return 'RFAL';
    }
  }
}

extension SwitchBool on bool {
  String get stringSwitch {
    return this ? 'ON' : 'OFF';
  }
}
