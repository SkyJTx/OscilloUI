import 'package:fluent_ui/fluent_ui.dart';
import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class LocaleEntry extends BaseEntryWithOptions<Locale?> {
  LocaleEntry._internal()
      : super(
          key: 'locale',
          defaultValue: 'system',
          title: 'Locale',
          description: 'Select the locale (language and time format) for the app',
          options: {
            'system': null,
            'en': Locale('en'),
            'th': Locale('th'),
          },
        );

  static final LocaleEntry _instance = LocaleEntry._internal();

  factory LocaleEntry() => _instance;
}
