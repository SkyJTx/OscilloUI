import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/errors/error_base.dart';
import 'package:oscillo_ui/repo/connections/connections_repo.dart';
import 'package:oscillo_ui/repo/database/entities/connection_set_entity.dart';

class ConnectionSetViewState extends Equatable {
  final bool isInitialized;
  final bool hasError;
  final ErrorBase? error;
  final List<ConnectionSetEntity> connections;
  final ConnectionSetEntity? selectedConnection;

  ConnectionSetViewState({
    this.isInitialized = false,
    this.hasError = false,
    this.error,
    this.connections = const [],
    this.selectedConnection,
  });

  ConnectionSetViewState copyWith({
    bool? isInitialized,
    bool? hasError,
    ErrorBase? error,
    List<ConnectionSetEntity>? connections,
    ConnectionSetEntity? selectedConnection,
  }) {
    return ConnectionSetViewState(
      isInitialized: isInitialized ?? this.isInitialized,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
      connections: connections ?? this.connections,
      selectedConnection: selectedConnection ?? this.selectedConnection,
    );
  }

  ConnectionSetViewState replaceWith({
    required bool isInitialized,
    required bool hasError,
    ErrorBase? error,
    required List<ConnectionSetEntity> connections,
    required ConnectionSetEntity? selectedConnection,
  }) {
    return ConnectionSetViewState(
      isInitialized: isInitialized,
      hasError: hasError,
      error: error,
      connections: connections,
      selectedConnection: selectedConnection,
    );
  }

  ConnectionSetViewState copyWithConnection({
    List<ConnectionSetEntity>? connections,
    ConnectionSetEntity? connection,
  }) {
    final newConnections = connections ?? this.connections;
    final newConnection = connection;
    if (newConnection != null) {
      final index = newConnections.indexWhere((c) => c.id == newConnection.id);
      if (index == -1) {
        newConnections.add(newConnection);
      } else {
        newConnections[index] = newConnection;
      }
    }

    return ConnectionSetViewState(
      isInitialized: isInitialized,
      hasError: hasError,
      error: error,
      connections: newConnections,
      selectedConnection: newConnection,
    );
  }

  ConnectionSetViewState copyWithNoError({
    bool? isInitialized,
    List<ConnectionSetEntity>? connections,
    ConnectionSetEntity? selectedConnection,
  }) {
    return ConnectionSetViewState(
      isInitialized: isInitialized ?? this.isInitialized,
      hasError: false,
      connections: connections ?? this.connections,
      selectedConnection: selectedConnection ?? this.selectedConnection,
    );
  }

  ConnectionSetViewState copyWithError({
    required ErrorBase error,
  }) {
    return ConnectionSetViewState(
      isInitialized: isInitialized,
      hasError: true,
      error: error,
      connections: connections,
      selectedConnection: selectedConnection,
    );
  }

  @override
  List<Object?> get props => [
        isInitialized,
        hasError,
        error,
        connections,
        selectedConnection,
      ];
}

class ConnectionSetViewCubit extends Cubit<ConnectionSetViewState> {
  final ConnectionsRepo _connectionsRepo = ConnectionsRepo();

  static ConnectionSetViewCubit? _singleton;

  ConnectionSetViewCubit._internal()
      : super(ConnectionSetViewState(
          isInitialized: false,
          connections: [],
          selectedConnection: null,
        ));

  factory ConnectionSetViewCubit() {
    return _singleton ??= ConnectionSetViewCubit._internal();
  }

  Future<void> _execute(Future<void> Function() action) async {
    final saveState = state;

    try {
      return action();
    } on ErrorBase catch (e) {
      emit(saveState.copyWithError(error: e));
    } catch (e, s) {
      emit(saveState.copyWithError(
        error: UnknownError(error: e, stackTrace: s),
      ));
    }
  }

  Future<void> init() async {
    await _execute(() async {
      final connections = await _connectionsRepo.fetch();
      emit(state.copyWithNoError(
        isInitialized: true,
        connections: connections,
      ));
    });
  }

  Future<void> selectConnection(ConnectionSetEntity? connection) async {
    emit(state.copyWith(selectedConnection: connection));
  }

  Future<void> addConnection(ConnectionSetEntity connection) async {
    await _execute(() async {
      final newConnections = await _connectionsRepo.add(connection);
      emit(state.copyWithConnection(connections: newConnections));
    });
  }

  Future<void> editConnection(ConnectionSetEntity connection) async {
    await _execute(() async {
      final newConnections = await _connectionsRepo.updateWithObject(connection);
      emit(state.copyWithConnection(connections: newConnections));
    });
  }

  Future<void> deleteConnection(ConnectionSetEntity connection) async {
    await _execute(() async {
      final newConnections = await _connectionsRepo.remove(connection);
      emit(state.copyWithConnection(connections: newConnections));
    });
  }

  Future<void> clearAllConnections() async {
    await _execute(() async {
      final newConnections = await _connectionsRepo.clear();
      emit(state.replaceWith(
        isInitialized: true,
        hasError: false,
        connections: newConnections,
        selectedConnection: null,
      ));
    });
  }
}
