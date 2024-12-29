import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class HostEntry extends BaseEntry {
  HostEntry._internal()
      : super(
          key: 'host',
          defaultValue: '',
          title: 'Host',
          description: 'Enter the host URL for the app',
        );

  static final HostEntry _instance = HostEntry._internal();

  factory HostEntry() => _instance;
}
