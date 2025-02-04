import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oscillo_ui/component/dialogs/error_dialog.dart';

part 'errors.dart';

abstract class ErrorBase {
  final String code;
  final String Function(BuildContext context) messageConstructor;
  final Object? error;
  final StackTrace? stackTrace;

  ErrorBase({
    required this.code,
    required this.messageConstructor,
    this.error,
    this.stackTrace,
  });

  Future<void> raise(BuildContext context) {
    return ErrorDialog.show(
      context,
      error: messageConstructor(context),
    );
  }
}
