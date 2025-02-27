import 'dart:async';
import 'dart:isolate';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:oscillo_ui/component/value_change_notifier/value_change_notifier.dart';
import 'package:oscillo_ui/repo/ui/ui_repo.dart';
import 'package:oscillo_ui/l10n/generated/app_localizations.dart';

class LoadingDialog extends StatelessWidget {
  final double? progress;

  LoadingDialog({super.key, this.progress}) {
    if (progress != null) {
      assert(progress! >= 0 && progress! <= 100);
    }
  }

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      transitionBuilder: _transitionBuilder,
      builder: (context) => LoadingDialog(),
    );
  }

  static Future<ReturnedValue> callAsync<ReturnedValue>(
    BuildContext context,
    Future<ReturnedValue> Function(double progress, void Function(double progress)) callback, {
    bool showProgress = false,
  }) {
    assert(false,
        'This method shouldn\'t be used in the main isolate. It will block everything such as, UI updates, etc.');
    final progressController = ValueChangeNotifer(0.0);
    showDialog(
      context: context,
      transitionBuilder: _transitionBuilder,
      builder: (context) => ValueChangeNotifierBuilder(
        valueChangeNotifier: progressController,
        builder: (context, value, setValue, child) {
          return LoadingDialog(
            progress: showProgress ? value : null,
          );
        },
      ),
    );
    return callback(
      progressController.value,
      (value) {
        if (!showProgress) return;
        if (progressController.value == double.parse(value.toStringAsFixed(0))) return;
        progressController.value = value.clamp(0, 100).toDouble();
      },
    ).whenComplete(() {
      UiRepo.navigator.pop();
    });
  }

  static Future<ReturnedValue> callIsolate<ReturnedValue>(
    BuildContext context,
    FutureOr<ReturnedValue> Function(double progress, void Function(double progress)) callback, {
    bool showProgress = false,
  }) async {
    final progressController = ValueChangeNotifer(0.0);
    showDialog(
      context: context,
      transitionBuilder: _transitionBuilder,
      builder: (context) => ValueChangeNotifierBuilder(
        valueChangeNotifier: progressController,
        builder: (context, value, setValue, child) {
          return LoadingDialog(
            progress: showProgress ? value : null,
          );
        },
      ),
    );

    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    final completer = Completer<ReturnedValue>();
    receivePort.listen((message) {
      if (message is double) {
        if (!showProgress) return;
        if (progressController.value == double.parse(message.toStringAsFixed(0))) return;
        progressController.value = message.clamp(0, 100).toDouble();
      } else if (message is ReturnedValue) {
        completer.complete(message);
      }
    });
    errorPort.listen((message) {
      final error = (message as List<dynamic>)[0];
      final stackTrace = StackTrace.fromString(message[1]);
      completer.completeError(error, stackTrace);
    });

    final isolate = await Isolate.spawn(
      _isolateEntry<ReturnedValue>,
      [
        receivePort.sendPort,
        callback,
      ],
      onError: errorPort.sendPort,
    );

    return completer.future.whenComplete(() {
      isolate.kill();
      receivePort.close();
      errorPort.close();
      UiRepo.navigator.pop();
    }).onError((error, stackTrace) {
      isolate.kill();
      receivePort.close();
      errorPort.close();
      throw error ?? Exception('Unknown error');
    });
  }

  static void _isolateEntry<ReturnedValue>(List<dynamic> msg) async {
    final port = msg[0] as SendPort;
    final callback =
        msg[1] as FutureOr<ReturnedValue> Function(double progress, void Function(double progress));
    double progress = 0.0;
    final value = await callback(
      progress,
      (newProgress) {
        progress = newProgress;
        port.send(newProgress);
      },
    );
    port.send(value);
  }

  static Future<List<ReturnedValue>> wait<ReturnedValue>(
    BuildContext context,
    Iterable<Future<ReturnedValue> Function()> callbacks, {
    bool progress = false,
  }) {
    final valueController = ValueChangeNotifer(0.0);
    final count = callbacks.length;
    showDialog(
      context: context,
      transitionBuilder: _transitionBuilder,
      builder: (context) => ValueChangeNotifierBuilder(
        valueChangeNotifier: valueController,
        builder: (context, value, setValue, child) {
          return LoadingDialog(
            progress: value,
          );
        },
      ),
    );
    return Future.wait(callbacks.map(
      (e) => e().then((value) {
        if (!progress) return value;
        final progressFinal = (valueController.value / 100 + 1 / count) * 100;
        if (double.parse(progressFinal.toStringAsFixed(0)) == valueController.value) return value;
        valueController.value = progressFinal.clamp(0, 100).toDouble();
        return value;
      }),
    )).whenComplete(() {
      UiRepo.navigator.pop();
    });
  }

  static Widget _transitionBuilder(
    BuildContext context,
    Animation<double> primaryAnimate,
    Animation<double> secondaryAnimate,
    Widget child,
  ) {
    return FadeTransition(
      opacity: primaryAnimate,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final brightness = theme.brightness;
    final foregroundColor =
        brightness == Brightness.light ? theme.micaBackgroundColor : Colors.white;
    final backgroundColor = brightness == Brightness.light ? theme.accentColor : Colors.black;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        spacing: 16.0,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: ProgressRing(
              strokeWidth: 7,
              backgroundColor: backgroundColor,
              activeColor: foregroundColor,
              value: progress?.clamp(0, 100).toDouble(),
            ),
          ),
          Builder(
            builder: (context) {
              late String finalProgressString;
              if (progress != null) {
                finalProgressString =
                    '${(progress! + 1).clamp(0, 100).toDouble().toStringAsFixed(0)}% ';
              } else {
                finalProgressString = '';
              }
              return Text(
                '$finalProgressString${AppLocalizations.of(context).waitingText}',
                style: FluentTheme.of(context).typography.bodyLarge?.copyWith(
                      color: foregroundColor,
                    ),
              );
            },
          )
        ],
      ),
    );
  }
}
