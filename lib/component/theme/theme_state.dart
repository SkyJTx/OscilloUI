import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:oscillo_ui/constant/theme.dart';

interface class ThemeState {
  final ThemeData Function() themeData;
  final TextTheme Function() textTheme;
  final ThemeMode Function() themeMode;
  final bool Function() isDark;

  ThemeState({
    required this.themeData,
    required this.textTheme,
    required this.themeMode,
    required this.isDark,
  });
}

final class DarkThemeState extends ThemeState {
  DarkThemeState() : super(
    themeData: () => darkTheme,
    textTheme: () => darkTextTheme,
    themeMode: () => ThemeMode.dark,
    isDark: () => true,
  );
}

final class LightThemeState extends ThemeState {
  LightThemeState() : super(
    themeData: () => lightTheme,
    textTheme: () => lightTextTheme,
    themeMode: () => ThemeMode.light,
    isDark: () => false,
  );
}

final class SystemThemeState extends ThemeState {
  SystemThemeState() : super(
    themeData: () {
      final Brightness brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark ? darkTheme : lightTheme;
    },
    textTheme: () {
      final Brightness brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark ? darkTextTheme : lightTextTheme;
    },
    themeMode: () => ThemeMode.system,
    isDark: () {
      final Brightness brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    },
  );
}
