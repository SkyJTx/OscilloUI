import 'package:fluent_ui/fluent_ui.dart';
import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';
import 'package:oscillo_ui/l10n/generated/app_localizations.dart';

class LocaleData {
  final Locale locale;
  final String language;
  final String defaultText;
  final AppLocalizations appLocalizations;

  LocaleData({
    required this.locale,
    required this.language,
    this.defaultText = 'Default',
    required this.appLocalizations,
  });
}

class LocaleEntry extends BaseEntryWithOptions<LocaleData?> {
  LocaleEntry._internal({
    Map<String, LocaleData?>? options,
  }) : super(
          key: 'locale',
          defaultValue: 'system',
          title: 'Locale',
          description: 'Select the locale (language and time format) for the app',
          options: options ??
              {
                'system': null,
              },
        );

  @override
  Future<LocaleEntry> rebase() async {
    final availableLocales = AppLocalizations.supportedLocales;
    final options = <String, LocaleData?>{
      'system': null,
    };
    for (final locale in availableLocales) {
      final appLocal = await AppLocalizations.delegate.load(locale);
      options[locale.toLanguageTag()] = LocaleData(
        locale: locale,
        language: appLocal.language,
        defaultText: appLocal.defaultText,
        appLocalizations: appLocal,
      );
    }
    _constructed = LocaleEntry._internal(options: options);
    return _constructed!;
  }

  static LocaleEntry? _constructed;

  static LocaleEntry get _instance {
    _constructed ??= LocaleEntry._internal();
    return _constructed!;
  }

  factory LocaleEntry() => _instance;
}
