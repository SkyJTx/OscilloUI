import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:oscillo_ui/l10n/generated/app_localizations.dart';

class ErrorDialog extends StatelessWidget {
  final Object? error;

  const ErrorDialog({super.key, this.error});

  static Future<void> show(
    BuildContext context, {
    Object? error,
  }) async {
    log('ErrorDialog.show: $error');
    await showDialog(
      context: context,
      builder: (context) => ErrorDialog(error: error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = FluentTheme.of(context);
    return ContentDialog(
      title: Text(locale.errorText, style: theme.typography.title),
      content: error != null
          ? ListView(
              shrinkWrap: true,
              children: [Text('$error')],
            )
          : null,
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(locale.acceptText),
        ),
      ],
    );
  }
}
