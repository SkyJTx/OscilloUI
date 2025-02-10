import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oscillo_ui/component/dialogs/error_dialog.dart';

part 'errors.dart';

abstract class ErrorBase {
  String code;
  String text;
  String Function(BuildContext context) messageConstructor;
  Object? error;
  StackTrace? stackTrace;

  ErrorBase({
    required this.code,
    required this.text,
    required this.messageConstructor,
    this.error,
    this.stackTrace,
  });

  Future<void> raise(BuildContext context) {
    return ErrorDialog.show(
      context,
      error: '${messageConstructor(context)}: $code',
    );
  }

  @override
  String toString() {
    return 'Error Status Code: $code - $text';
  }
}
