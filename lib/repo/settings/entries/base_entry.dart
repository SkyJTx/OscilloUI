import 'dart:async';

import 'package:oscillo_ui/objectbox.g.dart';
import 'package:oscillo_ui/repo/database/database_repo.dart';
import 'package:oscillo_ui/repo/database/entities/setting_entity.dart';

abstract class BaseEntry {
  final String key;
  final String defaultValue;
  final bool defaultEnabled;
  final String title;
  final String? description;

  Future<Result> txn<Result, Param>(
    TxMode mode,
    Result Function(Store, Param) callback,
    Param param,
  ) async {
    return StoreRepo().storeInstance.runInTransactionAsync<Result, Param>(
      mode,
      (store, param) {
        return callback(store, param);
      },
      param,
    );
  }

  BaseEntry({
    required this.key,
    required this.defaultValue,
    this.defaultEnabled = false,
    required this.title,
    this.description,
  });

  Map<String, Object?> get params => {
        'key': key,
        'defaultValue': defaultValue,
        'defaultEnabled': defaultEnabled,
        'title': title,
        'description': description,
        'options': null,
      };

  Future<void> init() async {
    return txn(TxMode.write, (store, p) {
      final box = store.box<SettingEntity>();
      final key = p['key'] as String;
      final defaultValue = p['defaultValue'] as String;
      final title = p['title'] as String;

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
    final r = txn(TxMode.read, (store, p) {
      final box = store.box<SettingEntity>();
      final key = p['key'] as String;
      final defaultValue = p['defaultValue'] as String;

      final entity = box
          .query(SettingEntity_.key.equals(
            key,
          ))
          .build()
          .findFirst();
      return entity?.value ?? defaultValue;
    }, params);

    return Future.value(r);
  }

  Future<void> setValue(String value) {
    final r = txn(TxMode.write, (store, p) {
      final box = store.box<SettingEntity>();
      final key = p['key'] as String;

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

    return Future.value(r);
  }

  Future<void> reset() {
    final r = txn(TxMode.write, (store, p) {
      final box = store.box<SettingEntity>();
      final key = p['key'] as String;
      final defaultValue = p['defaultValue'] as String;
      final title = p['title'] as String;

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

    return Future.value(r);
  }

  Future<void> delete() {
    final r = txn(TxMode.write, (store, p) {
      final box = store.box<SettingEntity>();
      final key = p['key'] as String;

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

    return Future.value(r);
  }
}

mixin Options<T> on BaseEntry {
  late Map<String, T> _options = {};

  Map<String, T> get options => _options;
}

abstract class BaseEntryWithOptions<T> extends BaseEntry with Options<T> {
  BaseEntryWithOptions({
    required super.key,
    required super.defaultValue,
    super.defaultEnabled,
    required super.title,
    super.description,
    required Map<String, T> options,
  }) {
    _options = options;
  }

  @override
  get params => super.params..['options'] = options;

  @override
  Future<void> init() async {
    return txn(TxMode.write, (store, p) {
      final box = store.box<SettingEntity>();
      final key = p['key'] as String;
      final defaultValue = p['defaultValue'] as String;
      final title = p['title'] as String;
      final options = p['options'] as Map<String, T>;

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
