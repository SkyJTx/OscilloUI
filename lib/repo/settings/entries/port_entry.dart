import 'package:oscillo_ui/objectbox.g.dart';
import 'package:oscillo_ui/repo/database/entities/setting_entity.dart';
import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class PortEntry extends BaseEntry {
  PortEntry._internal()
      : super(
          key: 'port',
          defaultValue: '8080',
          title: 'Port',
          description: 'Enter the port number for the app',
        );

  static final PortEntry _instance = PortEntry._internal();

  factory PortEntry() => _instance;

  @override
  Future<void> init() async {
    return await txn(TxMode.write, (store, p) {
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

  @override
  Future<String> get value async {
    return await txn(TxMode.read, (store, p) {
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

  @override
  Future<void> setValue(String value) async {
    return await txn(TxMode.write, (store, p) {
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

  @override
  Future<void> reset() async {
    return await setValue(defaultValue);
  }

  @override
  Future<void> delete() async {
    return await txn(TxMode.write, (store, p) {
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