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

  Future<List<ConnectionSetEntity>> add(ConnectionSetEntity connection) async {
    final newConnections = await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, params) {
        final box = store.box<ConnectionSetEntity>();
        box.put(params.connection);
        params.connections.add(params.connection);

        return params.connections;
      },
      (
        connections: _connections,
        connection: connection,
      ),
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
      (store, params) {
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
      (
        connections: _connections,
        connection: connection,
      ),
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }

  Future<List<ConnectionSetEntity>> remove(ConnectionSetEntity connection) async {
    final newConnections = await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, params) {
        final box = store.box<ConnectionSetEntity>();
        final index =
            params.connections.indexWhere((element) => element.id == params.connection.id);
        if (index != -1) {
          box.remove(params.connection.id);
          params.connections.removeAt(index);
        }

        return params.connections;
      },
      (
        connections: _connections,
        connection: connection,
      ),
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }

  Future<List<ConnectionSetEntity>> clear() async {
    final newConnections = await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, params) {
        final box = store.box<ConnectionSetEntity>();
        box.removeAll();
        params.connections.clear();

        return params.connections;
      },
      (connections: _connections),
    );

    _connections.clear();
    _connections.addAll(newConnections);

    return _connections;
  }
}
