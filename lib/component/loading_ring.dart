import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingRing extends StatelessWidget {
  final double? size;
  final double? strokeWidth;
  final double? value;

  const LoadingRing({
    super.key,
    this.size,
    this.strokeWidth,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 50.0,
          height: 50.0,
          child: ProgressRing(
            strokeWidth: 7,
            value: value?.clamp(0, 100).toDouble(),
          ),
        ),
        Builder(
          builder: (context) {
            late String finalProgressString;
            if (value != null) {
              finalProgressString =
                  '${(value! + 1).clamp(0, 100).toDouble().toStringAsFixed(0)}% ';
            } else {
              finalProgressString = '';
            }
            return Text(
              '$finalProgressString${AppLocalizations.of(context).waitingText}',
              style: FluentTheme.of(context).typography.bodyLarge,
            );
          },
        )
      ],
    );
  }
}
