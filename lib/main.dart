import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oscillo_ui/component/app_builder/locale_builder.dart';
import 'package:oscillo_ui/component/app_builder/theme_builder.dart';
import 'package:oscillo_ui/component/errors/error_cubit.dart';
import 'package:oscillo_ui/component/errors/error_base.dart';
import 'package:oscillo_ui/dependency_injector.dart';
import 'package:oscillo_ui/page/home.dart';
import 'package:oscillo_ui/page/main_page/oscilloscope_cubit.dart';
import 'package:oscillo_ui/page/settings_page/settings_cubit.dart';
import 'package:oscillo_ui/repo/connections/connections_repo.dart';
import 'package:oscillo_ui/repo/database/database_repo.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_repo.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';
import 'package:oscillo_ui/repo/ui/ui_repo.dart';
import 'package:sizer/sizer.dart';

void main() async {
  await DependencyInjector.init();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(
        value: OscilloscopeRepo(),
      ),
      RepositoryProvider.value(
        value: StoreRepo(),
      ),
      RepositoryProvider.value(
        value: SettingsRepo(),
      ),
      RepositoryProvider.value(
        value: ConnectionsRepo(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: SettingsCubit()..init(),
        ),
        BlocProvider.value(
          value: OscilloscopeCubit()..init(),
        ),
        BlocProvider.value(
          value: ErrorCubit(),
        ),
      ],
      child: MainApp(),
    ),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
  });

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ThemeBuilder(
          settingsCubit: context.read<SettingsCubit>(),
          builder: (context, currentTheme, lightTheme, darkTheme, themeMode) {
            return LocaleBuilder(
              settingsCubit: context.read<SettingsCubit>(),
              builder: (
                context,
                locale,
                systemLocale,
                supportLocales,
                localizationsDelegate,
                localization,
              ) {
                return FluentApp(
                  debugShowCheckedModeBanner: false,
                  navigatorKey: UiRepo.navigatorKey,
                  onGenerateTitle: (context) {
                    final title = localization(context, locale).title;
                    final description = localization(context, locale).description;
                    return '$title - $description';
                  },
                  localizationsDelegates: [
                    localizationsDelegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  locale: locale,
                  supportedLocales: supportLocales,
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: themeMode,
                  home: MultiBlocListener(
                    listeners: [
                      BlocListener<SettingsCubit, SettingsState>(
                        listenWhen: (previous, current) {
                          return current.hasError && current.error != null && previous.error != current.error;
                        },
                        listener: (context, state) {
                          if (state.hasError) {
                            ErrorCubit().setError(state.error!);
                          }
                        },
                      ),
                      BlocListener<OscilloscopeCubit, OscilloscopeState>(
                        listenWhen: (previous, current) {
                          return current.hasError && current.error != null && previous.error != current.error;
                        },
                        listener: (context, state) {
                          if (state.hasError) {
                            ErrorCubit().setError(state.error!);
                          }
                        },
                      ),
                      BlocListener<ErrorCubit, ErrorBase?>(
                        listener: (context, state) {
                          if (state != null) {
                            state.raise(context);
                            ErrorCubit().clearError();
                          }
                        },
                      ),
                    ],
                    child: Home(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
