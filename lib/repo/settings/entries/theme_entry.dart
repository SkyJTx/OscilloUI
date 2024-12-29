import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class ThemeEntry extends BaseEntryWithOptions {
  ThemeEntry._internal()
      : super(
          key: 'theme',
          defaultValue: 'system',
          title: 'Theme',
          description: 'Select the theme for the app',
          options: {
            'light': 'Light',
            'dark': 'Dark',
            'system': 'System',
          },
        );

  static final ThemeEntry _instance = ThemeEntry._internal();

  factory ThemeEntry() => _instance;
}
