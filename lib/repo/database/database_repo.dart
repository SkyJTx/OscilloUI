import 'package:oscillo_ui/objectbox.g.dart';
import 'package:oscillo_ui/repo/database/entities/connection_set_entity.dart';
import 'package:oscillo_ui/repo/database/entities/setting_entity.dart';
import 'package:path_provider/path_provider.dart';

class StoreRepo {
  static Store? _store;

  static final StoreRepo _instance = StoreRepo._internal();

  static Store get store {
    if (_store == null) {
      throw Exception('Store is not initialized');
    }
    return _store!;
  }

  StoreRepo._internal();

  factory StoreRepo() => _instance;

  static Future<StoreRepo> create() async {
    if (_store != null) {
      return _instance;
    }

    final directory = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: '${directory.path}/database',
    );
    _store = store;
    return _instance;
  }

  Box<SettingEntity> get settingsBox => store.box<SettingEntity>();
  Box<ConnectionSetEntity> get connectionSetBox => store.box<ConnectionSetEntity>();

  List<Box> get boxes => [settingsBox, connectionSetBox];

  bool get isOpen => _store != null;

  bool get isClosed => _store == null;

  Store get storeInstance {
    if (_store == null) {
      throw Exception('Store is not initialized');
    }
    return _store!;
  }

  void close() {
    _store?.close();
    _store = null;
  }
}
