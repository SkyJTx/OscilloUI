import 'package:fluent_ui/fluent_ui.dart';
import 'package:oscillo_ui/component/dialogs/error_dialog.dart';

class UiRepo {
  static final UiRepo _instance = UiRepo._internal();

  factory UiRepo() => _instance;

  UiRepo._internal();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigator {
    if (navigatorKey.currentState == null) {
      throw Exception('Navigator key is not attached to AppWidget');
    }
    return navigatorKey.currentState!;
  }

  static BuildContext get context {
    if (navigatorKey.currentState == null) {
      throw Exception('Navigator key is not attached to AppWidget');
    }
    return navigatorKey.currentContext!;
  }

  Future<void> showErrorDialog({
    BuildContext? context,
    Object? error,
  }) async {
    return ErrorDialog.show(
      context ?? UiRepo.context,
      error: error,
    );
  }

  Future<T?> showAnyDialog<T>({
    required Widget Function(BuildContext) builder,
  }) {
    return showDialog<T>(
      context: UiRepo.context,
      builder: builder,
    );
  }
}
