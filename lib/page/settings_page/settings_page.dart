import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/l10n/generated/app_localizations.dart';
import 'package:oscillo_ui/component/app_builder/locale_builder.dart';
import 'package:oscillo_ui/component/dialogs/error_dialog.dart';
import 'package:oscillo_ui/component/dialogs/loading_dialog.dart';
import 'package:oscillo_ui/page/settings_page/capture_path_dialog.dart';
import 'package:oscillo_ui/page/settings_page/connection_dialog.dart';
import 'package:oscillo_ui/page/settings_page/settings_cubit.dart';
import 'package:oscillo_ui/repo/settings/entries/locale_entry.dart';
import 'package:oscillo_ui/repo/ui/ui_repo.dart';
import 'package:sizer/sizer.dart';

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
  final hostTextFormBoxState = GlobalKey<TextFormBoxState>();
  final portTextFormBoxState = GlobalKey<TextFormBoxState>();
  final imageSavePathTextFormBoxState = GlobalKey<TextFormBoxState>();
  final videoSavePathTextFormBoxState = GlobalKey<TextFormBoxState>();
  final hostTextController = TextEditingController();
  final portTextController = TextEditingController();
  final imageSavePathTextController = TextEditingController();
  final videoSavePathTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hostTextFormBoxState.currentState?.validate();
    portTextFormBoxState.currentState?.validate();
    imageSavePathTextFormBoxState.currentState?.validate();
    videoSavePathTextFormBoxState.currentState?.validate();
  }

  @override
  void didChangeDependencies() {
    final state = context.read<SettingsCubit>().state;
    hostTextController.text = state.host.value;
    portTextController.text = state.port.value.toString();
    imageSavePathTextController.text = state.imageSavePath.value;
    videoSavePathTextController.text = state.videoSavePath.value;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = FluentTheme.of(context);
    final settingsCubit = context.read<SettingsCubit>();
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        hostTextController.text = state.host.value;
        portTextController.text = state.port.value.toString();
        imageSavePathTextController.text = state.imageSavePath.value;
        videoSavePathTextController.text = state.videoSavePath.value;
        hostTextFormBoxState.currentState?.validate();
        portTextFormBoxState.currentState?.validate();
        imageSavePathTextFormBoxState.currentState?.validate();
        videoSavePathTextFormBoxState.currentState?.validate();
      },
      builder: (context, state) {
        if (!state.isInitialized) {
          return Center(
            child: ProgressRing(),
          );
        }
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
                content: Padding(
                  padding: EdgeInsets.only(
                    left: [48, 4.w].reduce(min).toDouble(),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 200,
                              minWidth: [20.w, 200].reduce(min).toDouble(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                Text(
                                  '${locale.settingsPageHostSettingTitle}:',
                                  style: theme.typography.body,
                                ),
                                Text(
                                  '${locale.settingsPagePortSettingTitle}:',
                                  style: theme.typography.body,
                                ),
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 200,
                              minWidth: [20.w, 200].reduce(min).toDouble(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                SelectableText(
                                  state.host.value,
                                  style: theme.typography.body,
                                ),
                                SelectableText(
                                  state.port.value.toString(),
                                  style: theme.typography.body,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Button(
                        child: Text(locale.editText),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ConnectionDialog(
                                hostTextController: hostTextController,
                                portTextController: portTextController,
                                hostTextFormBoxState: hostTextFormBoxState,
                                portTextFormBoxState: portTextFormBoxState,
                                settingsCubit: settingsCubit,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
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
                content: Padding(
                  padding: EdgeInsets.only(
                    left: [48, 4.w].reduce(min).toDouble(),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 200,
                              minWidth: [20.w, 200].reduce(min).toDouble(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                Text(
                                  '${locale.settingsPageImageSavePathSettingTitle}:',
                                  style: theme.typography.body,
                                ),
                                Text(
                                  '${locale.settingsPageVideoSavePathSettingTitle}:',
                                  style: theme.typography.body,
                                ),
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 200,
                              minWidth: [20.w, 200].reduce(min).toDouble(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                SelectableText(
                                  state.imageSavePath.value,
                                  style: theme.typography.body,
                                ),
                                SelectableText(
                                  state.videoSavePath.value,
                                  style: theme.typography.body,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Button(
                        child: Text(locale.editText),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CapturePathDialog(
                                imageSavePathTextFormBoxState: imageSavePathTextFormBoxState,
                                videoSavePathTextFormBoxState: videoSavePathTextFormBoxState,
                                imageSavePathTextController: imageSavePathTextController,
                                videoSavePathTextController: videoSavePathTextController,
                                settingsCubit: settingsCubit,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
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
                content: LocaleBuilder(
                  builder: (
                    context,
                    locale,
                    systemLocale,
                    supportLocales,
                    localizationsDelegate,
                    localization,
                  ) {
                    LocaleData? systemLocaleData;
                    int maxMatch = 0;
                    for (final e in state.language.options.keys) {
                      if (e == null) continue;
                      int match = [
                        e.locale.languageCode == systemLocale.languageCode,
                        if (e.locale.scriptCode != null || systemLocale.scriptCode != null)
                          e.locale.scriptCode == systemLocale.scriptCode,
                        if (e.locale.countryCode != null || systemLocale.countryCode != null)
                          e.locale.countryCode == systemLocale.countryCode,
                      ].where((e) => e).length;
                      if (match > maxMatch) {
                        maxMatch = match;
                        systemLocaleData = e;
                      }
                    }
                    final languageList = state.language.options.keys.toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        languageList.length,
                        (index) {
                          final language = languageList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: RadioButton(
                              checked: state.language.value == language,
                              onChanged: (checked) {
                                if (checked) {
                                  settingsCubit.setLanguage(language);
                                }
                              },
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: language != null
                                    ? [
                                        Text(language.language),
                                      ]
                                    : [
                                        Text(
                                          systemLocaleData?.defaultText ??
                                              AppLocalizations.of(context).defaultText,
                                        ),
                                        Text(
                                          systemLocaleData?.language ??
                                              AppLocalizations.of(context).language,
                                          style: theme.typography.caption,
                                        ),
                                      ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                // content: Builder(
                //   builder: (context) {
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         for (final e in state.language.options.keys)
                //           Padding(
                //             padding: EdgeInsets.symmetric(vertical: 3),
                //             child: RadioButton(
                //               checked: state.language.value == e,
                //               onChanged: (checked) {
                //                 if (checked) {
                //                   settingsCubit.setLanguage(e);
                //                 }
                //               },
                //               content: Builder(
                //                 builder: (context) {
                //                   return Text(
                //                     e?.language ?? locale.systemLanguage,
                //                   );
                //                 }
                //               ),
                //             ),
                //           ),
                //       ],
                //     );
                //   },
                // ),
                // content: Builder(
                //   builder: (context) {
                //     ({String title}) languageCreator(Locale? inputLocale) => switch (inputLocale) {
                //           null => (title: locale.settingsPageLanguageSettingOptionSystem,),
                //           Locale(languageCode: 'en') => (
                //               title: locale.settingsPageLanguageSettingOptionEnglish,
                //             ),
                //           Locale(languageCode: 'th') => (
                //               title: locale.settingsPageLanguageSettingOptionThai,
                //             ),
                //           _ => throw Exception('Unknown locale: $inputLocale'),
                //         };
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         for (final e in state.language.options.keys) ...[
                //           SizedBox(height: 3),
                //           RadioButton(
                //             checked: state.language.value == e,
                //             onChanged: (checked) {
                //               if (checked) {
                //                 settingsCubit.setLanguage(e);
                //               }
                //             },
                //             content: Text(languageCreator(e).title),
                //           ),
                //           SizedBox(height: 3),
                //         ],
                //       ],
                //     );
                //   },
                // ),
              ),
              if (kDebugMode) ...[
                SizedBox(height: 8),
                Expander(
                  header: ListTile(
                    leading: Icon(FluentIcons.bug),
                    title: Text(
                      "Debug",
                      style: theme.typography.body,
                    ),
                    subtitle: Text(
                      "Debugging tools (English only)",
                      style: theme.typography.caption,
                    ),
                  ),
                  content: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 150),
                        child: FilledButton(
                          child: Text("Show Error"),
                          onPressed: () {
                            UiRepo().showErrorDialog(error: "Test error");
                          },
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 150),
                        child: FilledButton(
                          child: Text("Show Fatal Error"),
                          onPressed: () {},
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 150),
                        child: FilledButton(
                          child: Text("Show Synchronous Task Loading"),
                          onPressed: () async {
                            try {
                              final result = await LoadingDialog.callIsolate(
                                context,
                                (value, setValue) async {
                                  final loop = 1_000_000_000;
                                  for (var i = 0; i < loop; i++) {
                                    if (i % (loop / 100) == 0) {
                                      setValue(i / (loop / 100));
                                    }
                                  }
                                  return "Test result";
                                },
                                showProgress: true,
                              );
                              debugPrint(result.toString());
                            } catch (e, _) {
                              if (!context.mounted) return;
                              ErrorDialog.show(context, error: e);
                            }
                          },
                        ),
                      ),
                    ]
                        .map((e) => Column(
                              children: [
                                SizedBox(height: 4),
                                e,
                                SizedBox(height: 4),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
