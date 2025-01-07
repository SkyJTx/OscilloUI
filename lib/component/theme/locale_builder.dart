import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/constant/theme.dart';
import 'package:oscillo_ui/page/settings_page/settings_cubit.dart';

class LocaleBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Locale? locale) builder;
  final SettingsCubit settingsCubit;

  const LocaleBuilder({
    super.key,
    required this.builder,
    required this.settingsCubit,
  });

  @override
  State<LocaleBuilder> createState() => LocaleBuilderState();
}

class LocaleBuilderState extends State<LocaleBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: widget.settingsCubit,
      builder: (context, state) {
        if (!state.isInitialized) {
          return FluentTheme(
            data: systemTheme,
            child: Center(
              child: ProgressRing(),
            ),
          );
        }
        return widget.builder(context, state.language.value);
      },
    );
  }
}
