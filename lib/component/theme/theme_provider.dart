import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/theme/theme_state.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';

class ThemeProvider extends Cubit<ThemeState> {
  final _settingsRepository = SettingsRepo();
  ThemeProvider() : super(SystemThemeState());

  Future<void> init() async {
    await _settingsRepository.init().onError((error, stackTrace) {
      log('Error initializing settings: $error', stackTrace: stackTrace, error: error);
      SystemNavigator.pop();
    });
    await _settingsRepository.theme.value.then((theme) {
      switch (theme) {
        case 'light':
          emit(LightThemeState());
          break;
        case 'dark':
          emit(DarkThemeState());
          break;
        case 'system':
          emit(SystemThemeState());
          break;
        default:
          emit(SystemThemeState());
      }
    }).onError((error, stackTrace) {
      log('Error getting theme: $error', stackTrace: stackTrace, error: error);
    });
  }

  Future<void> setTheme(String theme) async {
    final prevState = state;
    switch (theme) {
      case 'light':
        emit(LightThemeState());
        break;
      case 'dark':
        emit(DarkThemeState());
        break;
      case 'system':
        emit(SystemThemeState());
        break;
    }
    await _settingsRepository.theme.setValue(theme).onError((error, stackTrace) {
      emit(prevState);
    });
  }
}
