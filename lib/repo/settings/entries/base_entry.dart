import 'package:oscillo_ui/repo/database/database_repo.dart';
import 'package:oscillo_ui/repo/database/entities/setting_entity.dart';

abstract class BaseEntry {
  final String key;
  final String defaultValue;
  final bool defaultEnabled;
  final String title;
  final String? description;
  final DateTime createdAt;
  DateTime updatedAt;

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
    required this.createdAt,
    required this.updatedAt,
  });

  Future<bool> get isEnabled async => true;

  Future<String> get value;

  Future<void> setValue(String value);

  Future<void> reset();

  Future<void> delete();
}

mixin Options<T> on BaseEntry {
  late List<T> _options = [];

  List<T> get options => _options;
}

abstract class BaseEntryWithOptions extends BaseEntry with Options<String> {
  BaseEntryWithOptions({
    required super.key,
    required super.defaultValue,
    super.defaultEnabled,
    required super.title,
    super.description,
    required List<String> options,
    required super.createdAt,
    required super.updatedAt,
  }) {
    _options = options;
  }
}
