import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oscillo_ui/page/settings_page/settings_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final themeScroller = ScrollController();
  final themeExpanderState = GlobalKey<ExpanderState>();
  final languageExpanderState = GlobalKey<ExpanderState>();
  final connectionExpanderState = GlobalKey<ExpanderState>();
  final captureExpanderState = GlobalKey<ExpanderState>();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = FluentTheme.of(context);
    final settingsCubit = context.read<SettingsCubit>();
    return BlocSelector<SettingsCubit, SettingsState, bool>(
      selector: (state) {
        return state.isInitialized;
      },
      builder: (context, isInitialized) {
        if (!isInitialized) {
          return Center(
            child: ProgressRing(),
          );
        }
        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                padding: EdgeInsets.all(8),
                children: [
                  ListTile(
                    leading: Icon(FluentIcons.settings),
                    title: Text(
                      locale.settingsPageTitle,
                      style: theme.typography.title,
                    ),
                    subtitle: Text(
                      locale.settingsPageSubtitle,
                      style: theme.typography.subtitle,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expander(
                    key: connectionExpanderState,
                    header: ListTile(
                      leading: Icon(FluentIcons.info),
                      title: Text(
                        locale.settingsPageConnectionSettingTitle,
                        style: theme.typography.body,
                      ),
                      subtitle: Text(
                        locale.settingsPageConnectionSettingSubtitle,
                        style: theme.typography.caption,
                      ),
                    ),
                    onStateChanged: (value) {
                      if (value) {
                        captureExpanderState.currentState?.isExpanded = false;
                        themeExpanderState.currentState?.isExpanded = false;
                        languageExpanderState.currentState?.isExpanded = false;
                      }
                    },
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              locale.settingsPageHostSettingTitle,
                              style: theme.typography.body,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextBox(
                                placeholder: locale.settingsPageHostSettingSubtitle,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              locale.settingsPagePortSettingTitle,
                              style: theme.typography.body,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextBox(
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                placeholder: locale.settingsPagePortSettingSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Expander(
                    key: captureExpanderState,
                    header: ListTile(
                      leading: Icon(FluentIcons.file_image),
                      title: Text(
                        locale.settingsPageCaptureSettingTitle,
                        style: theme.typography.body,
                      ),
                      subtitle: Text(
                        locale.settingsPageCaptureSettingSubtitle,
                        style: theme.typography.caption,
                      ),
                    ),
                    onStateChanged: (value) {
                      if (value) {
                        connectionExpanderState.currentState?.isExpanded = false;
                        themeExpanderState.currentState?.isExpanded = false;
                        languageExpanderState.currentState?.isExpanded = false;
                      }
                    },
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              locale.settingsPageImageSavePathSettingTitle,
                              style: theme.typography.body,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextBox(
                                placeholder: locale.settingsPageImageSavePathSettingSubtitle,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              locale.settingsPageVideoSavePathSettingTitle,
                              style: theme.typography.body,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextBox(
                                placeholder: locale.settingsPageVideoSavePathSettingSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Expander(
                    key: themeExpanderState,
                    header: ListTile(
                      leading: Icon(FluentIcons.color),
                      title: Text(
                        locale.settingsPageThemeSettingTitle,
                        style: theme.typography.body,
                      ),
                      subtitle: Text(
                        locale.settingsPageThemeSettingSubtitle,
                        style: theme.typography.caption,
                      ),
                    ),
                    onStateChanged: (value) {
                      if (value) {
                        connectionExpanderState.currentState?.isExpanded = false;
                        captureExpanderState.currentState?.isExpanded = false;
                        languageExpanderState.currentState?.isExpanded = false;
                      }
                    },
                    content: Builder(
                      builder: (context) {
                        ({IconData icon, String title}) themeCreator(ThemeMode theme) =>
                            switch (theme) {
                              ThemeMode.light => (
                                  icon: FluentIcons.sunny,
                                  title: locale.settingsPageThemeSettingOptionLight,
                                ),
                              ThemeMode.dark => (
                                  icon: FluentIcons.clear_night,
                                  title: locale.settingsPageThemeSettingOptionDark,
                                ),
                              ThemeMode.system => (
                                  icon: FluentIcons.system,
                                  title: locale.settingsPageThemeSettingOptionSystem,
                                ),
                            };
                        return Center(
                          child: Scrollbar(
                            controller: themeScroller,
                            child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 110),
                                  child: ListView(
                                    controller: themeScroller,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    children: [
                                      for (final themeMode in state.theme.options.keys) ...[
                                        SizedBox(width: 4),
                                        Button(
                                          style: state.theme.value == themeMode
                                              ? ButtonStyle(
                                                  foregroundColor: WidgetStateProperty.all(
                                                      theme.micaBackgroundColor),
                                                  backgroundColor:
                                                      WidgetStateProperty.all(theme.selectionColor),
                                                )
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              spacing: 8,
                                              children: [
                                                Icon(
                                                  themeCreator(themeMode).icon,
                                                  size: 50,
                                                ),
                                                Text(
                                                  themeCreator(themeMode).title,
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {
                                            settingsCubit.setTheme(themeMode);
                                          },
                                        ),
                                        SizedBox(width: 4),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Expander(
                    key: languageExpanderState,
                    header: ListTile(
                      leading: Icon(FluentIcons.locale_language),
                      title: Text(
                        locale.settingsPageLanguageSettingTitle,
                        style: theme.typography.body,
                      ),
                      subtitle: Text(
                        locale.settingsPageLanguageSettingSubtitle,
                        style: theme.typography.caption,
                      ),
                    ),
                    onStateChanged: (value) {
                      if (value) {
                        connectionExpanderState.currentState?.isExpanded = false;
                        captureExpanderState.currentState?.isExpanded = false;
                        themeExpanderState.currentState?.isExpanded = false;
                      }
                    },
                    content: Builder(
                      builder: (context) {
                        ({String title}) languageCreator(Locale? inputLocale) =>
                            switch (inputLocale) {
                              null => (title: locale.settingsPageLanguageSettingOptionSystem,),
                              Locale(languageCode: 'en') => (
                                  title: locale.settingsPageLanguageSettingOptionEnglish,
                                ),
                              Locale(languageCode: 'th') => (
                                  title: locale.settingsPageLanguageSettingOptionThai,
                                ),
                              _ => throw Exception('Unknown locale: $inputLocale'),
                            };
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final e in state.language.options.keys) ...[
                              SizedBox(height: 3),
                              RadioButton(
                                checked: state.language.value == e,
                                onChanged: (checked) {
                                  if (checked) {
                                    settingsCubit.setLanguage(e);
                                  }
                                },
                                content: Text(languageCreator(e).title),
                              ),
                              SizedBox(height: 3),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
