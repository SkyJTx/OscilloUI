import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class LocaleEntry extends BaseEntryWithOptions {
  LocaleEntry._internal()
      : super(
          key: 'locale',
          defaultValue: 'en',
          title: 'Locale',
          description: 'Select the locale (language and time format) for the app',
          options: {
            'en': 'English (International)',
            'th': 'Thai (Thailand)',
          },
        );

  static final LocaleEntry _instance = LocaleEntry._internal();

  factory LocaleEntry() => _instance;
}
