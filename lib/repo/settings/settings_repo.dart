import 'package:oscillo_ui/repo/database/database_repo.dart';

class SettingsRepo {
  static final storeRepo = StoreRepo();

  static final SettingsRepo _instance = SettingsRepo._internal();

  static SettingsRepo get instance => _instance;

  SettingsRepo._internal() {
    StoreRepo.create();
  }

  factory SettingsRepo() => _instance;
}
