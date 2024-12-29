import 'package:oscillo_ui/objectbox.g.dart';
import 'package:oscillo_ui/repo/database/database_repo.dart';
import 'package:oscillo_ui/repo/database/entities/setting_entity.dart';

abstract class BaseEntry {
  final String key;
  final String defaultValue;
  final bool defaultEnabled;
  final String title;
  final String? description;

  final storeRepo = StoreRepo();
  final box = StoreRepo().storeInstance.box<SettingEntity>();
  final run = StoreRepo().storeInstance.runAsync;
  final txn = StoreRepo().storeInstance.runInTransactionAsync;

  BaseEntry({
    required this.key,
    required this.defaultValue,
    this.defaultEnabled = false,
    required this.title,
    this.description,
  });

  ({
    String key,
    String defaultValue,
    bool defaultEnabled,
    String title,
    String? description,
    Box<SettingEntity> box,
    Map<String, String>? options,
  }) get params => (
        key: key,
        defaultValue: defaultValue,
        defaultEnabled: defaultEnabled,
        title: title,
        description: description,
        box: box,
        options: null,
      );

  Future<void> init() async {
    return txn(TxMode.write, (store, p) {
      final box = p.box;
      final key = p.key;
      final defaultValue = p.defaultValue;
      final title = p.title;

      final entity = box
          .query(SettingEntity_.key.equals(
            key,
          ))
          .build()
          .findFirst();
      if (entity == null) {
        box.put(SettingEntity(
          key: key,
          value: defaultValue,
          title: title,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }
    }, params);
  }

  Future<bool> get isEnabled async => defaultEnabled;

  Future<String> get value {
    return txn(TxMode.read, (store, p) {
      final box = p.box;
      final key = p.key;
      final defaultValue = p.defaultValue;

      final entity = box
          .query(SettingEntity_.key.equals(
            key,
          ))
          .build()
          .findFirst();
      return entity?.value ?? defaultValue;
    }, params);
  }

  Future<void> setValue(String value) {
    return txn(TxMode.write, (store, p) {
      final box = p.box;
      final key = p.key;

      final entity = box
          .query(SettingEntity_.key.equals(
            key,
          ))
          .build()
          .findFirst();
      if (entity != null) {
        entity.value = value;
        entity.updatedAt = DateTime.now();
        box.put(entity);
      }
    }, params);
  }

  Future<void> reset() {
    return txn(TxMode.write, (store, p) {
      final box = p.box;
      final key = p.key;

      final entity = box
          .query(SettingEntity_.key.equals(
            key,
          ))
          .build()
          .findFirst();
      if (entity != null) {
        entity.value = defaultValue;
        entity.updatedAt = DateTime.now();
        box.put(entity);
      } else {
        box.put(SettingEntity(
          key: key,
          value: defaultValue,
          title: title,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }
    }, params);
  }

  Future<void> delete() {
    return txn(TxMode.write, (store, p) {
      final box = p.box;
      final key = p.key;

      final entity = box
          .query(SettingEntity_.key.equals(
            key,
          ))
          .build()
          .findFirst();
      if (entity != null) {
        box.remove(entity.id);
      }
    }, params);
  }
}

mixin Options<T> on BaseEntry {
  late Map<T, String> _options = {};

  Map<T, String> get options => _options;
}

abstract class BaseEntryWithOptions extends BaseEntry with Options<String> {
  BaseEntryWithOptions({
    required super.key,
    required super.defaultValue,
    super.defaultEnabled,
    required super.title,
    super.description,
    required Map<String, String> options,
  }) {
    _options = options;
  }

  @override
  ({
    String key,
    String defaultValue,
    bool defaultEnabled,
    String title,
    String? description,
    Box<SettingEntity> box,
    Map<String, String> options,
  }) get params => (
        key: key,
        defaultValue: defaultValue,
        defaultEnabled: defaultEnabled,
        title: title,
        description: description,
        box: box,
        options: options,
      );
  
  @override
  Future<void> init() async {
    return txn(TxMode.write, (store, p) {
      final box = p.box;
      final key = p.key;
      final defaultValue = p.defaultValue;
      final title = p.title;
      final options = p.options;

      final entity = box
          .query(SettingEntity_.key.equals(
            key,
          ))
          .build()
          .findFirst();
      if (entity == null) {
        box.put(SettingEntity(
          key: key,
          value: defaultValue,
          title: title,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      } else {
        if (!options.containsKey(entity.value)) {
          entity.value = defaultValue;
          entity.updatedAt = DateTime.now();
          box.put(entity);
        }
      }
    }, params);
  }

  @override
  Future<void> setValue(String value) {
    if (!options.containsKey(value)) throw Exception('Invalid value');

    return super.setValue(value);
  }
}
