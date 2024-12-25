import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/theme/theme_provider.dart';
import 'package:oscillo_ui/component/theme/theme_state.dart';
import 'package:oscillo_ui/constant/theme.dart';

class ThemeBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    ThemeData lightTheme,
    ThemeData darkTheme,
    ThemeMode themeMode,
  ) builder;

  const ThemeBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeProvider()..init(),
      child: BlocBuilder<ThemeProvider, ThemeState>(
        builder: (context, state) {
          return builder(
            context,
            lightTheme,
            darkTheme,
            state.themeMode(),
          );
        },
      ),
    );
  }
}
