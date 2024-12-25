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

  Future<void> init();

  Future<bool> get isEnabled async => defaultEnabled;

  Future<String> get value;

  Future<void> setValue(String value);

  Future<void> reset();

  Future<void> delete();
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
}
