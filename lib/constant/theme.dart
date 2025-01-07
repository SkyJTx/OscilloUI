import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';

final _lightTheme = FluentThemeData(
  brightness: Brightness.light,
  accentColor: Colors.orange,
);

final _darkTheme = FluentThemeData(
  brightness: Brightness.dark,
  accentColor: Colors.orange,
);

FluentThemeData get lightTheme => _lightTheme;

FluentThemeData get darkTheme => _darkTheme;

FluentThemeData get systemTheme {
  final Brightness brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
  return brightness == Brightness.dark ? darkTheme : lightTheme;
}
