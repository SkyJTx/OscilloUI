import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/dialogs/loading_dialog.dart';
import 'package:oscillo_ui/component/errors/error_base.dart';
import 'package:oscillo_ui/constant/oscilloscope.dart';
import 'package:oscillo_ui/data_models/oscilloscope_data/oscilloscope_data.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_repo.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_video_command.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';
import 'package:oscillo_ui/repo/ui/ui_repo.dart';

class OscilloscopeState extends Equatable {
  late final int id;
  final bool isInitialized;
  final bool isConnected;
  final bool hasError;
  final List<({String hostname, int port})> connections;
  final ErrorBase? error;
  final OscilloscopeData? data;

  OscilloscopeState({
    int? id,
    required this.isInitialized,
    required this.isConnected,
    required this.hasError,
    this.connections = const [],
    this.error,
    this.data,
  }) {
    this.id = id ?? DateTime.now().millisecondsSinceEpoch;
  }

  OscilloscopeState copyWith({
    bool? isInitialized,
    bool? isConnected,
    bool? hasError,
    ErrorBase? error,
    List<({String hostname, int port})>? connections,
    OscilloscopeData? data,
  }) {
    return OscilloscopeState(
      id: DateTime.now().millisecondsSinceEpoch,
      isInitialized: isInitialized ?? this.isInitialized,
      isConnected: isConnected ?? this.isConnected,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
      connections: connections ?? this.connections,
      data: data,
    );
  }

  OscilloscopeState copyWithData({
    bool? isInitialized,
    bool? isConnected,
    OscilloscopeData? data,
    List<({String hostname, int port})>? connections,
  }) {
    return OscilloscopeState(
      id: DateTime.now().millisecondsSinceEpoch,
      isInitialized: isInitialized ?? this.isInitialized,
      isConnected: isConnected ?? this.isConnected,
      hasError: false,
      error: null,
      connections: connections ?? this.connections,
      data: data ?? this.data,
    );
  }

  OscilloscopeState copyWithError(ErrorBase error) {
    return OscilloscopeState(
      id: DateTime.now().millisecondsSinceEpoch,
      isInitialized: isInitialized,
      isConnected: isConnected,
      hasError: true,
      error: error,
      connections: connections,
      data: data,
    );
  }

  OscilloscopeState copyWithNoError({
    bool? isInitialized,
    bool? isConnected,
    OscilloscopeData? data,
    List<({String hostname, int port})>? connections,
  }) {
    return OscilloscopeState(
      id: DateTime.now().millisecondsSinceEpoch,
      isInitialized: isInitialized ?? this.isInitialized,
      isConnected: isConnected ?? this.isConnected,
      hasError: false,
      error: null,
      connections: connections ?? this.connections,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        id,
        isInitialized,
        isConnected,
        hasError,
        error,
        connections,
        data,
      ];
}

class OscilloscopeCubit extends Cubit<OscilloscopeState> {
  StreamSubscription<ImageByteWithTimestamp>? _videoSub;

  OscilloscopeCubit._internal() : super(defaultState);

  static final OscilloscopeCubit _instance = OscilloscopeCubit._internal();
  static final OscilloscopeState defaultState = OscilloscopeState(
    isInitialized: false,
    isConnected: false,
    hasError: false,
  );

  factory OscilloscopeCubit({
    OscilloscopeState? state,
  }) {
    if (state != null) _instance.emit(state);
    return _instance;
  }

  Future<void> init() async {
    final saveState = state;
    try {
      emit(defaultState);
      final connections = [
        (
          hostname: await SettingsRepo().host.value,
          port: int.parse(await SettingsRepo().port.value),
        ),
      ]; //! To be replaced with actual connections
      emit(state.copyWithNoError(
        isInitialized: true,
        connections: connections,
      ));
    } catch (e, s) {
      emit(saveState.copyWithError(UnknownError(
        error: e,
        stackTrace: s,
      )));
    }
  }

  Future<void> fetchConnections() async {
    final saveState = state;
    try {
      final connections = [
        (
          hostname: await SettingsRepo().host.value,
          port: int.parse(await SettingsRepo().port.value),
        ),
      ]; //! To be replaced with actual connections
      emit(state.copyWithNoError(
        connections: connections,
      ));
    } catch (e, s) {
      emit(saveState.copyWithError(UnknownError(
        error: e,
        stackTrace: s,
      )));
    }
  }

  Future<void> connect(
    String ip,
    int port,
  ) async {
    OscilloscopeState saveState = state;
    LoadingDialog.show(UiRepo.context);
    try {
      await OscilloscopeRepo().connect(ip, port);
      emit(state.copyWithNoError(
        isConnected: true,
      ));
    } on ErrorBase catch (e, s) {
      UiRepo.navigator.pop();
      emit(saveState.copyWithError(e..stackTrace = s));
      await OscilloscopeRepo().disconnect();
      _videoSub?.cancel();
      _videoSub = null;
      return;
    } catch (e, s) {
      UiRepo.navigator.pop();
      emit(saveState.copyWithError(UnknownError(
        error: e,
        stackTrace: s,
      )));
      await OscilloscopeRepo().disconnect();
      _videoSub?.cancel();
      _videoSub = null;
      return;
    }

    saveState = state;
    try {
      final data = await OscilloscopeRepo().apiProvider.getAll();
      UiRepo.navigator.pop();
      emit(state.copyWithData(
        data: data.copyWith(
          videoCommandType: OscilloscopeVideoCommandType.resume,
        ),
      ));
      _videoSub = OscilloscopeRepo().videoStream.listen(
        (event) {
          if (!state.isConnected) {
            _videoSub?.cancel();
            return;
          }
          emit(state.copyWithData(
            data: state.data!.copyWith(
              videoFrames: [
                ...state.data!.videoFrames,
                event,
              ],
            ),
          ));
        },
      );
    } on ErrorBase catch (e, s) {
      UiRepo.navigator.pop();
      emit(saveState.copyWithError(e..stackTrace = s));
      await OscilloscopeRepo().disconnect();
      _videoSub?.cancel();
      _videoSub = null;
    } catch (e, s) {
      UiRepo.navigator.pop();
      emit(saveState.copyWithError(UnknownError(
        error: e,
        stackTrace: s,
      )));
      await OscilloscopeRepo().disconnect();
      _videoSub?.cancel();
      _videoSub = null;
    }
  }

  Future<void> disconnect() async {
    final saveState = state;
    LoadingDialog.show(UiRepo.context);
    try {
      await OscilloscopeRepo().disconnect();
      UiRepo.navigator.pop();
      emit(state.copyWithNoError(
        isConnected: false,
        data: state.data?.copyWith(
          videoCommandType: OscilloscopeVideoCommandType.stop,
        ),
      ));
      _videoSub?.cancel();
      _videoSub = null;
    } catch (e, s) {
      UiRepo.navigator.pop();
      emit(saveState.copyWithError(
        RequestError(
          error: e,
          stackTrace: s,
        ),
      ));
    }
  }

  Future<void> play() async {
    final saveState = state;
    try {
      await OscilloscopeRepo().sendVideoCommand(OscilloscopeVideoCommandType.resume);
      emit(state.copyWithNoError(
        data: state.data?.copyWith(
          videoCommandType: OscilloscopeVideoCommandType.resume,
        ),
      ));
    } on UnsupportedPlatformError catch (e) {
      emit(saveState.copyWithError(e));
    } catch (e, s) {
      emit(saveState.copyWithError(
        UnknownError(
          error: e,
          stackTrace: s,
        ),
      ));
    }
  }

  Future<void> pause() async {
    final saveState = state;
    try {
      await OscilloscopeRepo().sendVideoCommand(OscilloscopeVideoCommandType.pause);
      emit(state.copyWithNoError(
        data: state.data?.copyWith(
          videoCommandType: OscilloscopeVideoCommandType.pause,
        ),
      ));
    } on UnsupportedPlatformError catch (e) {
      emit(saveState.copyWithError(e));
    } catch (e, s) {
      emit(saveState.copyWithError(
        UnknownError(
          error: e,
          stackTrace: s,
        ),
      ));
    }
  }

  Future<void> reset() async {
    final saveState = state;
    try {
      await disconnect();
      emit(defaultState);
      await init();
    } catch (e, s) {
      emit(saveState.copyWithError(
        RequestError(
          error: e,
          stackTrace: s,
        ),
      ));
    }
  }

  Future<void> capture({String? fileName}) async {
    final saveState = state;
    try {
      await OscilloscopeRepo().capture(fileName: fileName);
    } on UnsupportedPlatformError catch (e) {
      emit(saveState.copyWithError(e));
    } catch (e, s) {
      emit(saveState.copyWithError(
        UnknownError(
          error: e,
          stackTrace: s,
        ),
      ));
    }
  }
}
