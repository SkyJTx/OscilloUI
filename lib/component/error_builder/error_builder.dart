import 'dart:math';
import 'dart:developer' as dev;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:oscillo_ui/component/errors/error_base.dart';
import 'package:oscillo_ui/constant/theme.dart';
import 'package:oscillo_ui/repo/ui/ui_repo.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorBuilder extends StatelessWidget {
  final FlutterErrorDetails details;

  const ErrorBuilder(
    this.details, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localeSet = AppLocalizations.of(context);
    return Sizer(builder: (context, orientation, deviceType) {
      return FluentApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: Padding(
          padding: EdgeInsets.all([10.w, 10.h].reduce(min)),
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ':(',
                    style: FluentTheme.of(context).typography.display?.copyWith(
                          fontSize: 128,
                        ),
                  ),
                  Text(
                    localeSet.fatalErrorText,
                    style: FluentTheme.of(context).typography.title,
                  ),
                ],
              ),
              Builder(
                builder: (_) {
                  if (details.exception is ErrorBase) {
                    final error = details.exception as ErrorBase;
                    return Text(
                      '${localeSet.errorText}: ${error.messageConstructor(context)}',
                      style: FluentTheme.of(context).typography.bodyLarge,
                    );
                  }
                  return Text(
                    '${localeSet.errorText}: ${details.exceptionAsString()}',
                    style: FluentTheme.of(context).typography.bodyLarge,
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
