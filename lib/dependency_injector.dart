import 'package:flutter/widgets.dart';
import 'package:oscillo_ui/repo/database/database_repo.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';

class DependencyInjector {
  Future<void> init() async {
    final widgetBinding = WidgetsFlutterBinding.ensureInitialized();
    await StoreRepo.create();
    await SettingsRepo().init();
  }
}
