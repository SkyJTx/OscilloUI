import 'dart:async';

import 'package:oscillo_ui/objectbox.g.dart';
import 'package:oscillo_ui/repo/database/database_repo.dart';
import 'package:oscillo_ui/repo/database/entities/connection_set_entity.dart';

class ConnectionsRepo {
  static final List<ConnectionSetEntity> _connections = [];

  static List<ConnectionSetEntity> get connections => _connections;

  static StoreRepo get storeRepo => StoreRepo();

  static final ConnectionsRepo _instance = ConnectionsRepo._internal();

  factory ConnectionsRepo() => _instance;

  ConnectionsRepo._internal();

  Future<List<ConnectionSetEntity>> fetch() async {
    return await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.read,
      (store, connections) {
        final box = store.box<ConnectionSetEntity>();
        final connectionsSet = box.getAll();
        connections.clear();
        connections.addAll(connectionsSet);

        return connections;
      },
      _connections,
    );
  }

  Future<List<ConnectionSetEntity>> add(
    ConnectionSetEntity connection,
  ) async {
    final newConnections = await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) {
        final params = (
          connections: p[0] as List<ConnectionSetEntity>,
          connection: p[1] as ConnectionSetEntity,
        );
        final box = store.box<ConnectionSetEntity>();
        box.put(params.connection);
        params.connections.add(params.connection);

        return params.connections;
      },
      [
        _connections,
        connection,
      ],
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }

  Future<List<ConnectionSetEntity>> updateWithObject(
    ConnectionSetEntity connection,
  ) async {
    final newConnections = await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) {
        final params = (
          connections: p[0] as List<ConnectionSetEntity>,
          connection: p[1] as ConnectionSetEntity,
        );
        final box = store.box<ConnectionSetEntity>();
        final index = params.connections.indexWhere(
          (element) => element.id == params.connection.id,
        );
        if (index != -1) {
          box.put(params.connection);
          params.connections[index] = params.connection;
        }

        return params.connections;
      },
      [
        _connections,
        connection,
      ],
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }

  Future<List<ConnectionSetEntity>> update(
    ConnectionSetEntity connection, {
    String? name,
    String? host,
    int? port,
  }) async {
    final newConnections = await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) {
        final params = (
          connections: p[0] as List<ConnectionSetEntity>,
          connection: p[1] as ConnectionSetEntity,
        );
        final box = store.box<ConnectionSetEntity>();
        final index = params.connections.indexWhere(
          (element) => element.id == params.connection.id,
        );
        if (index != -1) {
          params.connection.name = name ?? connection.name;
          params.connection.host = host ?? connection.host;
          params.connection.port = port ?? connection.port;
          box.put(params.connection);
          params.connections[index] = params.connection;
        }

        return params.connections;
      },
      [
        _connections,
        connection,
      ],
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }

  Future<List<ConnectionSetEntity>> remove(ConnectionSetEntity connection) async {
    final newConnections = await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) {
        final params = (
          connections: p[0] as List<ConnectionSetEntity>,
          connection: p[1] as ConnectionSetEntity,
        );
        final box = store.box<ConnectionSetEntity>();
        final index =
            params.connections.indexWhere((element) => element.id == params.connection.id);
        if (index != -1) {
          box.remove(params.connection.id);
          params.connections.removeAt(index);
        }

        return params.connections;
      },
      [
        _connections,
        connection,
      ],
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }

  Future<List<ConnectionSetEntity>> removeBy({
    int? id,
    int? index,
    String? name,
    String? host,
    int? port,
    bool batchRemove = false,
  }) async {
    assert(
      id != null || index != null || name != null || host != null || port != null,
      'At least one of the parameters must be provided',
    );

    final newConnections = await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) {
        final params = (
          connections: p[0] as List<ConnectionSetEntity>,
          id: p[1] as int?,
          index: p[2] as int?,
          name: p[3] as String?,
          host: p[4] as String?,
          port: p[5] as int?,
          batchRemove: p[6] as bool,
        );
        final box = store.box<ConnectionSetEntity>();
        final connections = params.connections;
        final toRemove = <ConnectionSetEntity>[];

        if (params.id != null) {
          final entity = box.get(params.id!);
          if (entity != null) {
            toRemove.add(entity);
          }
        } else if (params.index != null) {
          if (params.index! >= 0 && params.index! < connections.length) {
            toRemove.add(connections[params.index!]);
          }
        } else {
          toRemove.addAll(connections.where((element) {
            return (params.name != null && element.name == params.name) ||
                (params.host != null && element.host == params.host) ||
                (params.port != null && element.port == params.port);
          }));
        }

        for (final entity in toRemove) {
          box.remove(entity.id);
          connections.remove(entity);
        }

        return connections;
      },
      [
        _connections,
        id,
        index,
        name,
        host,
        port,
        batchRemove,
      ]
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }

  Future<List<ConnectionSetEntity>> removeByCondition({
    required FutureOr<bool> Function(
      ConnectionSetEntity entity,
    ) condition,
    bool batchRemove = false,
  }) async {
    final newConnections = await await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) async {
        final params = (
          connections: p[0] as List<ConnectionSetEntity>,
          condition: p[1] as FutureOr<bool> Function(ConnectionSetEntity entity),
          batchRemove: p[2] as bool,
        );
        final box = store.box<ConnectionSetEntity>();
        final connections = params.connections;
        final toRemove = <ConnectionSetEntity>[];

        for (final entity in connections) {
          if (await params.condition(entity)) {
            toRemove.add(entity);
          }
        }

        for (final entity in toRemove) {
          box.remove(entity.id);
          connections.remove(entity);
        }

        return connections;
      },
      [
        _connections,
        condition,
        batchRemove,
      ],
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }

  Future<List<ConnectionSetEntity>> clear() async {
    final newConnections = await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, connections) {
        final box = store.box<ConnectionSetEntity>();
        box.removeAll();
        connections.clear();

        return connections;
      },
      _connections,
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }
}
