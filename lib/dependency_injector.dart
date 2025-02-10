import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oscillo_ui/component/error_builder/error_builder.dart';
import 'package:oscillo_ui/objectbox.g.dart';
import 'package:oscillo_ui/repo/database/database_repo.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';

class DependencyInjector {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    ErrorWidget.builder = (details) {
      return ErrorBuilder(details);
    };

    await SettingsRepo().init();

    if (kDebugMode) {
      try {
        Admin(StoreRepo().storeInstance);
      } catch (e, s) {
        log('Admin is not available: $e', error: e, stackTrace: s);
      }
    }
  }
}
