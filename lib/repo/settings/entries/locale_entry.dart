import 'package:oscillo_ui/objectbox.g.dart';
import 'package:oscillo_ui/repo/database/entities/setting_entity.dart';
import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class LocaleEntry extends BaseEntryWithOptions {
  LocaleEntry._internal()
      : super(
          key: 'locale',
          defaultValue: 'en',
          title: 'Locale',
          description: 'Select the locale (language and time format) for the app',
          options: {
            'en': 'English (International)',
            'th': 'Thai (Thailand)',
          },
        );

  static final LocaleEntry _instance = LocaleEntry._internal();

  factory LocaleEntry() => _instance;

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
    if (!options.containsKey(value)) throw Exception('Invalid value');

    await txn(TxMode.write, (store, params) {
      final box = params.box;
      final key = params.key;
      final title = params.title;

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
    }, params);
  }

  @override
  Future<void> reset() async {
    await txn(TxMode.write, (store, p) {
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

  @override
  Future<void> delete() async {
    await txn(TxMode.write, (store, p) {
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
