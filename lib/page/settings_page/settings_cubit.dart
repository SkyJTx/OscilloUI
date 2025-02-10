import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/errors/error_base.dart';
import 'package:oscillo_ui/repo/settings/entries/locale_entry.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';

class Setting<Value> extends Equatable {
  final String key;
  final Value value;
  final bool enabled;

  const Setting({
    required this.key,
    required this.value,
    this.enabled = false,
  });

  Setting<Value> copyWith({
    String? key,
    Value? value,
    bool? enabled,
  }) {
    return Setting(
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
    );
  }

  Setting<Value> forceCopyWith({
    String? key,
    required Value value,
    bool? enabled,
  }) {
    return Setting(
      key: key ?? this.key,
      value: value,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object?> get props {
    return [key, value, enabled];
  }
}

class SettingWithOptions<Value> extends Setting<Value> {
  final Map<Value, String> options;

  const SettingWithOptions({
    required super.key,
    required super.value,
    super.enabled,
    required this.options,
  });

  @override
  SettingWithOptions<Value> copyWith({
    String? key,
    Value? value,
    bool? enabled,
    Map<Value, String>? options,
  }) {
    return SettingWithOptions(
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      options: options ?? this.options,
    );
  }

  @override
  SettingWithOptions<Value> forceCopyWith({
    String? key,
    required Value value,
    bool? enabled,
    Map<Value, String>? options,
  }) {
    return SettingWithOptions(
      key: key ?? this.key,
      value: value,
      enabled: enabled ?? this.enabled,
      options: options ?? this.options,
    );
  }

  @override
  List<Object?> get props => [...super.props, options];
}

class SettingsState extends Equatable {
  final bool isInitialized;
  final bool hasError;
  final ErrorBase? error;
  final StackTrace? stackTrace;
  final SettingWithOptions<ThemeMode> theme;
  final SettingWithOptions<LocaleData?> language;
  final Setting<String> host;
  final Setting<int> port;
  final Setting<String> imageSavePath;
  final Setting<String> videoSavePath;

  const SettingsState({
    this.isInitialized = false,
    this.hasError = false,
    this.error,
    this.stackTrace,
    required this.theme,
    required this.language,
    required this.host,
    required this.port,
    required this.imageSavePath,
    required this.videoSavePath,
  });

  SettingsState copyWith({
    bool? isInitialized,
    bool? hasError,
    ErrorBase? error,
    StackTrace? stackTrace,
    SettingWithOptions<ThemeMode>? theme,
    SettingWithOptions<LocaleData?>? language,
    Setting<String>? host,
    Setting<int>? port,
    Setting<String>? imageSavePath,
    Setting<String>? videoSavePath,
  }) {
    return SettingsState(
      isInitialized: isInitialized ?? this.isInitialized,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      host: host ?? this.host,
      port: port ?? this.port,
      imageSavePath: imageSavePath ?? this.imageSavePath,
      videoSavePath: videoSavePath ?? this.videoSavePath,
    );
  }

  SettingsState copyWithNoError({
    bool? isInitialized,
    SettingWithOptions<ThemeMode>? theme,
    SettingWithOptions<LocaleData?>? language,
    Setting<String>? host,
    Setting<int>? port,
    Setting<String>? imageSavePath,
    Setting<String>? videoSavePath,
  }) {
    return SettingsState(
      isInitialized: isInitialized ?? this.isInitialized,
      hasError: false,
      error: null,
      stackTrace: null,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      host: host ?? this.host,
      port: port ?? this.port,
      imageSavePath: imageSavePath ?? this.imageSavePath,
      videoSavePath: videoSavePath ?? this.videoSavePath,
    );
  }

  @override
  List<Object?> get props => [
        isInitialized,
        hasError,
        error,
        stackTrace,
        theme,
        language,
        host,
        port,
        imageSavePath,
        videoSavePath,
      ];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          isInitialized: false,
          hasError: false,
          error: null,
          stackTrace: null,
          theme: SettingWithOptions<ThemeMode>(
            key: SettingsRepo().theme.key,
            value:
                SettingsRepo().theme.options[SettingsRepo().theme.defaultValue] ?? ThemeMode.system,
            enabled: SettingsRepo().theme.defaultEnabled,
            options: {
              for (var MapEntry(key: key, value: value) in SettingsRepo().theme.options.entries)
                value: key,
            },
          ),
          language: SettingWithOptions<LocaleData?>(
            key: SettingsRepo().locale.key,
            value:
                SettingsRepo().locale.options[SettingsRepo().locale.defaultValue],
            enabled: SettingsRepo().locale.defaultEnabled,
            options: {
              for (var MapEntry(key: key, value: value) in SettingsRepo().locale.options.entries)
                value: key,
            },
          ),
          host: Setting(
            key: SettingsRepo().host.key,
            value: SettingsRepo().host.defaultValue,
            enabled: SettingsRepo().host.defaultEnabled,
          ),
          port: Setting(
            key: SettingsRepo().port.key,
            value: int.parse(SettingsRepo().port.defaultValue),
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
      state = state.copyWithNoError(
        isInitialized: true,
        theme: state.theme.copyWith(
          value: SettingsRepo().theme.options[await SettingsRepo().theme.value]!,
        ),
        language: state.language.forceCopyWith(
          value: SettingsRepo().locale.options[await SettingsRepo().locale.value],
        ),
        host: state.host.copyWith(
          value: await SettingsRepo().host.value,
        ),
        port: state.port.copyWith(
          value: int.parse(await SettingsRepo().port.value),
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
      state = prevState.copyWith(
        hasError: true,
        error: UnknownError(
          error: UnknownError(
          error: e,
          stackTrace: s,
        ),
          stackTrace: s,
        ),
        stackTrace: s,
      );
    }
  }

  Future<void> setTheme(ThemeMode value) async {
    final prevState = state;

    try {
      await SettingsRepo().theme.setValue(
            state.theme.options[value]!,
          );
      state = state.copyWithNoError(
        theme: state.theme.copyWith(
          value: value,
        ),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = prevState.copyWith(
        hasError: true,
        error: UnknownError(
          error: UnknownError(
          error: e,
          stackTrace: s,
        ),
          stackTrace: s,
        ),
        stackTrace: s,
      );
    }
  }

  Future<void> setLanguage(LocaleData? value) async {
    final prevState = state;

    try {
      await SettingsRepo().locale.setValue(
            state.language.options[value]!,
          );

      state = state.copyWithNoError(
        language: state.language.forceCopyWith(
          value: value,
        ),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = prevState.copyWith(
        hasError: true,
        error: UnknownError(
          error: UnknownError(
          error: e,
          stackTrace: s,
        ),
          stackTrace: s,
        ),
        stackTrace: s,
      );
    }
  }

  Future<void> setHost(String value) async {
    final prevState = state;

    try {
      await SettingsRepo().host.setValue(value);
      state = state.copyWithNoError(
        host: state.host.copyWith(
          value: value,
        ),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = prevState.copyWith(
        hasError: true,
        error: UnknownError(
          error: e,
          stackTrace: s,
        ),
        stackTrace: s,
      );
    }
  }

  Future<void> setPort(int value) async {
    final prevState = state;

    try {
      await SettingsRepo().port.setValue(value.toString());
      state = state.copyWithNoError(
        port: state.port.copyWith(
          value: value,
        ),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = prevState.copyWith(
        hasError: true,
        error: UnknownError(
          error: e,
          stackTrace: s,
        ),
        stackTrace: s,
      );
    }
  }

  Future<void> setImageSavePath(String value) async {
    final prevState = state;

    try {
      await SettingsRepo().imageSavePath.setValue(value);
      state = state.copyWithNoError(
        imageSavePath: state.imageSavePath.copyWith(
          value: value,
        ),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = prevState.copyWith(
        hasError: true,
        error: UnknownError(
          error: e,
          stackTrace: s,
        ),
        stackTrace: s,
      );
    }
  }

  Future<void> setVideoSavePath(String value) async {
    final prevState = state;

    try {
      await SettingsRepo().videoSavePath.setValue(value);
      state = state.copyWithNoError(
        videoSavePath: state.videoSavePath.copyWith(
          value: value,
        ),
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      state = prevState.copyWith(
        hasError: true,
        error: UnknownError(
          error: e,
          stackTrace: s,
        ),
        stackTrace: s,
      );
    }
  }
}
