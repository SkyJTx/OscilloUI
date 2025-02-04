import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/errors/error_base.dart';
import 'package:oscillo_ui/constant/oscilloscope.dart';
import 'package:oscillo_ui/data_models/oscilloscope_data/oscilloscope_data.dart';
import 'package:oscillo_ui/data_models/oscilloscope_data/trigger_data.dart';
import 'package:oscillo_ui/repo/oscilloscope/oscilloscope_repo.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';

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
      data: data ?? this.data,
    );
  }

  OscilloscopeState copyWithData({
    bool? isInitialized,
    bool? isConnected,
    OscilloscopeData? data,
  }) {
    return OscilloscopeState(
      id: DateTime.now().millisecondsSinceEpoch,
      isInitialized: isInitialized ?? this.isInitialized,
      isConnected: isConnected ?? this.isConnected,
      hasError: false,
      error: null,
      connections: connections,
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

  OscilloscopeCubit._internal()
      : super(
          OscilloscopeState(
            isInitialized: false,
            isConnected: false,
            hasError: false,
          ),
        );

  static final OscilloscopeCubit _instance = OscilloscopeCubit._internal();

  factory OscilloscopeCubit({
    OscilloscopeState? state,
  }) {
    if (state != null) _instance.emit(state);
    return _instance;
  }

  Future<void> init() async {
    final saveState = state;
    try {
      final connections = [
        (
          hostname: await SettingsRepo().host.value,
          port: int.parse(await SettingsRepo().port.value),
        ),
      ];
      emit(saveState.copyWith(
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

  Future<void> connect(
    String ip,
    int port,
  ) async {
    final saveState = state;
    try {
      await OscilloscopeRepo().connect(ip, port);
      final data = await OscilloscopeRepo().apiProvider.getAll();
      emit(saveState.copyWithData(
        isInitialized: true,
        isConnected: true,
        data: data,
      ));
      _videoSub = OscilloscopeRepo().videoStream.listen(
        (event) {
          if (!state.isConnected) {
            _videoSub?.cancel();
            return;
          }
          emit(saveState.copyWithData(
            data: saveState.data!.copyWith(
              videoFrames: [
                ...saveState.data!.videoFrames,
                event,
              ],
            ),
          ));
        },
      );
    } catch (e, s) {
      emit(saveState.copyWithError(RequestError(
        error: e,
        stackTrace: s,
      )));
      _videoSub?.cancel();
    }
  }

  Future<void> disconnect() async {
    final saveState = state;
    try {
      await OscilloscopeRepo().disconnect();
      emit(saveState.copyWith(
        isConnected: false,
      ));
    } catch (e, s) {
      emit(saveState.copyWithError(
        RequestError(
          error: e,
          stackTrace: s,
        ),
      ));
    }
    _videoSub?.cancel();
    _videoSub = null;
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
