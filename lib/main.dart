import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oscillo_ui/component/theme/theme_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (
        context,
        currentTheme,
        lightTheme,
        darkTheme,
        themeMode,
      ) {
        return MaterialApp(
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
          supportedLocales: AppLocalizations.supportedLocales,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: const Scaffold(
            body: Center(
              child: Text('Hello, World!'),
            ),
          ),
        );
      },
    );
  }
}
