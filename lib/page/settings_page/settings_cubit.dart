import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';

class Setting extends Equatable {
  final String key;
  final String value;
  final bool enabled;

  const Setting({
    required this.key,
    required this.value,
    this.enabled = false,
  });

  Setting copyWith({
    String? key,
    String? value,
    bool? enabled,
  }) {
    return Setting(
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object> get props => [key, value, enabled];
}

class SettingWithOptions extends Setting {
  final Map<String, String> options;

  const SettingWithOptions({
    required super.key,
    required super.value,
    super.enabled,
    required this.options,
  });

  @override
  SettingWithOptions copyWith({
    String? key,
    String? value,
    bool? enabled,
    Map<String, String>? options,
  }) {
    return SettingWithOptions(
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      options: options ?? this.options,
    );
  }

  @override
  List<Object> get props => [...super.props, options];
}

class SettingsState extends Equatable {
  final SettingWithOptions theme;
  final SettingWithOptions language;
  final Setting host;
  final Setting port;
  final Setting imageSavePath;
  final Setting videoSavePath;

  const SettingsState({
    required this.theme,
    required this.language,
    required this.host,
    required this.port,
    required this.imageSavePath,
    required this.videoSavePath,
  });

  SettingsState copyWith({
    SettingWithOptions? theme,
    SettingWithOptions? language,
    Setting? host,
    Setting? port,
    Setting? imageSavePath,
    Setting? videoSavePath,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      host: host ?? this.host,
      port: port ?? this.port,
      imageSavePath: imageSavePath ?? this.imageSavePath,
      videoSavePath: videoSavePath ?? this.videoSavePath,
    );
  }

  @override
  List<Object> get props => [theme, language, host, port, imageSavePath, videoSavePath];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          theme: SettingWithOptions(
            key: SettingsRepo().theme.key,
            value: SettingsRepo().theme.defaultValue,
            enabled: SettingsRepo().theme.defaultEnabled,
            options: SettingsRepo().theme.options,
          ),
          language: SettingWithOptions(
            key: SettingsRepo().locale.key,
            value: SettingsRepo().locale.defaultValue,
            enabled: SettingsRepo().locale.defaultEnabled,
            options: SettingsRepo().locale.options,
          ),
          host: Setting(
            key: SettingsRepo().host.key,
            value: SettingsRepo().host.defaultValue,
            enabled: SettingsRepo().host.defaultEnabled,
          ),
          port: Setting(
            key: SettingsRepo().port.key,
            value: SettingsRepo().port.defaultValue,
            enabled: SettingsRepo().port.defaultEnabled,
          ),
          imageSavePath: Setting(
            key: SettingsRepo().imageSavePath.key,
            value: SettingsRepo().imageSavePath.defaultValue,
            enabled: SettingsRepo().imageSavePath.defaultEnabled,
          ),
          videoSavePath: Setting(
            key: SettingsRepo().videoSavePath.key,
            value: SettingsRepo().videoSavePath.defaultValue,
            enabled: SettingsRepo().videoSavePath.defaultEnabled,
          ),
        ));

  set state(state) => emit(state);

  Future<void> init() async {
    final prevState = state;

    try {
      state = state.copyWith(
        theme: state.theme.copyWith(
          value: await SettingsRepo().theme.value,
        ),
        language: state.language.copyWith(
          value: await SettingsRepo().locale.value,
        ),
        host: state.host.copyWith(
          value: await SettingsRepo().host.value,
        ),
        port: state.port.copyWith(
          value: await SettingsRepo().port.value,
        ),
        imageSavePath: state.imageSavePath.copyWith(
          value: await SettingsRepo().imageSavePath.value,
        ),
        videoSavePath: state.videoSavePath.copyWith(
          value: await SettingsRepo().videoSavePath.value,
        ),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = prevState;
    }
  }
}
