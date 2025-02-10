import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/constant/theme.dart';
import 'package:oscillo_ui/page/settings_page/settings_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleBuilder extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    Locale? locale,
    Locale systemLocale,
    List<Locale> supportedLocales,
    LocalizationsDelegate localizationsDelegate,
    AppLocalizations Function(BuildContext, Locale?) localization,
  ) builder;
  final SettingsCubit? settingsCubit;

  const LocaleBuilder({
    super.key,
    required this.builder,
    this.settingsCubit,
  });

  @override
  State<LocaleBuilder> createState() => LocaleBuilderState();
}

class LocaleBuilderState extends State<LocaleBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: widget.settingsCubit,
      builder: (context, state) {
        if (!state.isInitialized) {
          return FluentTheme(
            data: systemTheme,
            child: Center(
              child: ProgressRing(),
            ),
          );
        }
        return widget.builder(
          context,
          state.language.value?.locale,
          View.of(context).platformDispatcher.locale,
          state.language.options.keys.where((e) => e != null).map((e) => e!.locale).toList(),
          AppLocalizations.delegate,
          (context, locale) {
            return state.language.options.entries
                    .firstWhere(
                      (e) => e.key?.locale == locale,
                      orElse: () => MapEntry(null, ''),
                    )
                    .key
                    ?.appLocalizations ??
                AppLocalizations.of(context);
          },
        );
      },
    );
  }
}
