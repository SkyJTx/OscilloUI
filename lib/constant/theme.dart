import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _lightTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.amber,
    brightness: Brightness.light,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  ),
);

final _darkTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.amber,
    brightness: Brightness.dark,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  ),
);

final lightTextTheme = GoogleFonts.kanitTextTheme(_lightTheme.textTheme);
final darkTextTheme = GoogleFonts.kanitTextTheme(_darkTheme.textTheme);

final lightTheme = _lightTheme.copyWith(
  textTheme: lightTextTheme,
);

final darkTheme = _darkTheme.copyWith(
  textTheme: darkTextTheme,
);
