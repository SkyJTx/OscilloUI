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

  Future<void> fetch() async {
    return await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.read,
      (store, p) {
        final box = store.box<ConnectionSetEntity>();
        final connectionsSet = box.getAll();
        _connections.clear();
        _connections.addAll(connectionsSet);
      },
      null,
    );
  }

  Future<void> add(ConnectionSetEntity connection) async {
    return await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) {
        final box = store.box<ConnectionSetEntity>();
        box.put(connection);
        _connections.add(connection);
      },
      null,
    );
  }

  Future<void> update(
    ConnectionSetEntity connection, {
    String? name,
    String? host,
    int? port,
  }) async {
    return await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) {
        final box = store.box<ConnectionSetEntity>();
        final index = _connections.indexWhere((element) => element.id == connection.id);
        if (index != -1) {
          connection.name = name ?? connection.name;
          connection.host = host ?? connection.host;
          connection.port = port ?? connection.port;
          box.put(connection);
          _connections[index] = connection;
        }
      },
      null,
    );
  }

  Future<void> remove(ConnectionSetEntity connection) async {
    return await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) {
        final box = store.box<ConnectionSetEntity>();
        final index = _connections.indexWhere((element) => element.id == connection.id);
        if (index != -1) {
          box.remove(connection.id);
          _connections.removeAt(index);
        }
      },
      null,
    );
  }

  Future<void> clear() async {
    return await storeRepo.storeInstance.runInTransactionAsync(
      TxMode.write,
      (store, p) {
        final box = store.box<ConnectionSetEntity>();
        box.removeAll();
        _connections.clear();
      },
      null,
    );
  }
}
