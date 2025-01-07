import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oscillo_ui/component/theme/locale_builder.dart';
import 'package:oscillo_ui/component/theme/theme_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oscillo_ui/dependency_injector.dart';
import 'package:oscillo_ui/page/home.dart';
import 'package:oscillo_ui/page/settings_page/settings_cubit.dart';
import 'package:oscillo_ui/repo/connections/connections_repo.dart';
import 'package:oscillo_ui/repo/database/database_repo.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_repo.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';
import 'package:oscillo_ui/repo/ui/ui_repo.dart';
import 'package:sizer/sizer.dart';

void main() async {
  await DependencyInjector().init();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => OscilloscopeRepo(),
      ),
      RepositoryProvider(
        create: (context) => StoreRepo(),
      ),
      RepositoryProvider(
        create: (context) => SettingsRepo(),
      ),
      RepositoryProvider(
        create: (context) => ConnectionsRepo(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsCubit()..init(),
          lazy: false,
        ),
      ],
      child: const MainApp(),
    ),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ThemeBuilder(
          settingsCubit: context.read<SettingsCubit>(),
          builder: (
            context,
            currentTheme,
            lightTheme,
            darkTheme,
            themeMode,
          ) {
            return LocaleBuilder(
                settingsCubit: context.read<SettingsCubit>(),
                builder: (context, locale) {
                  return FluentApp(
                    debugShowCheckedModeBanner: false,
                    navigatorKey: UiRepo.navigatorKey,
                    onGenerateTitle: (context) {
                      final title = AppLocalizations.of(context)!.title;
                      final description = AppLocalizations.of(context)!.description;
                      return '$title - $description';
                    },
                    localizationsDelegates: [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    locale: locale,
                    supportedLocales: AppLocalizations.supportedLocales,
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: themeMode,
                    home: Home(),
                  );
                });
          },
        );
      },
    );
  }
}
