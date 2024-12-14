import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ThemeState = ({
  ThemeData themeData,
  TextTheme textTheme,
  ThemeMode themeMode,
  bool isDark,
});

class ThemeProvider extends Cubit<ThemeState> {
  ThemeProvider(super.state);
}
