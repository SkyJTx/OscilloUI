import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/constant/theme.dart';
import 'package:oscillo_ui/page/settings_page/settings_cubit.dart';

class ThemeBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    FluentThemeData currentTheme,
    FluentThemeData lightTheme,
    FluentThemeData darkTheme,
    ThemeMode themeMode,
  ) builder;

  final SettingsCubit? settingsCubit;

  const ThemeBuilder({
    super.key,
    this.settingsCubit,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (!state.isInitialized) {
          return FluentTheme(
            data: systemTheme,
            child: Center(
              child: ProgressRing(),
            ),
          );
        }
        return builder(
          context,
          switch (state.theme.value) {
            ThemeMode.light => lightTheme,
            ThemeMode.dark => darkTheme,
            ThemeMode.system => systemTheme,
          },
          lightTheme,
          darkTheme,
          state.theme.value,
        );
      },
    );
  }
}
