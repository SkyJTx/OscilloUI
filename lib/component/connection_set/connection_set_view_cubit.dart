import 'dart:collection';

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
        //TODO: Implement ErrorBase
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

  ConnectionSetViewCubit()
      : super(ConnectionSetViewState(
          isInitialized: false,
          connections: [],
          selectedConnection: null,
        ));

  Future<void> init() async {}

  Future<void> selectConnection(ConnectionSetEntity? connection) async {}

  Future<void> addConnection(ConnectionSetEntity connection) async {}

  Future<void> editConnection(ConnectionSetEntity connection) async {}

  Future<void> deleteConnection(ConnectionSetEntity connection) async {}

  Future<void> clearAllConnections() async {}
}
