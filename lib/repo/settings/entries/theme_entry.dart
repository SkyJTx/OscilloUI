import 'package:oscillo_ui/objectbox.g.dart';
import 'package:oscillo_ui/repo/database/entities/setting_entity.dart';
import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class ThemeEntry extends BaseEntryWithOptions {
  ThemeEntry._internal()
      : super(
          key: 'theme',
          defaultValue: 'light',
          title: 'Theme',
          description: 'Select the theme for the app',
          options: {
            'light': 'Light',
            'dark': 'Dark',
            'system': 'System',
          },
        );

  static final ThemeEntry _instance = ThemeEntry._internal();

  factory ThemeEntry() => _instance;

  @override
  Future<void> init() async {
    return await txn(TxMode.write, (store, params) {
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
    }, null);
  }

  @override
  Future<String> get value async {
    return await txn(TxMode.read, (store, params) {
      final entity = box
          .query(SettingEntity_.key.equals(
            key,
          ))
          .build()
          .findFirst();
      return entity?.value ?? defaultValue;
    }, null);
  }

  @override
  Future<void> setValue(String value) async {
    await txn(TxMode.write, (store, params) {
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
      } else {
        box.put(SettingEntity(
          key: key,
          value: value,
          title: title,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }
    }, null);
  }

  @override
  Future<void> reset() async {
    await txn(TxMode.write, (store, params) {
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
    }, null);
  }

  @override
  Future<void> delete() async {
    await txn(TxMode.write, (store, params) {
      final entity = box
          .query(SettingEntity_.key.equals(
            key,
          ))
          .build()
          .findFirst();
      if (entity != null) {
        box.remove(entity.id);
      }
    }, null);
  }
}
