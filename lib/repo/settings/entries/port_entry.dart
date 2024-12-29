import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class PortEntry extends BaseEntry {
  PortEntry._internal()
      : super(
          key: 'port',
          defaultValue: '8080',
          title: 'Port',
          description: 'Enter the port number for the app',
        );

  static final PortEntry _instance = PortEntry._internal();

  factory PortEntry() => _instance;
}