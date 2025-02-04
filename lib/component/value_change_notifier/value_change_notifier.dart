import 'package:flutter/widgets.dart';

class ValueChangeNotifer<T extends Object?> extends ValueNotifier<T> {
  ValueChangeNotifer(super.value) {
    stringController = TextEditingController(text: value.toString());
    addListener(() {
      stringController.text = value.toString();
    });
  }

  @override
  void dispose() {
    stringController.dispose();
    super.dispose();
  }

  late final TextEditingController stringController;
}

class ValueChangeNotifierBuilder<T extends Object?> extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    T value,
    void Function(T value) setValue,
    Widget? child,
  ) builder;

  final ValueChangeNotifer<T> valueChangeNotifier;
  final Widget? child;

  const ValueChangeNotifierBuilder({
    super.key,
    required this.builder,
    required this.valueChangeNotifier,
    this.child,
  });

  static ValueChangeNotifierBuilder<Q> easy<Q extends Object?>({
    required Widget Function(
      BuildContext context,
      Q value,
      void Function(Q value) setValue,
      Widget? child,
    ) builder,
    required Q initialValue,
    void Function(ValueChangeNotifer<Q> valueChangeNotifier)? onInit,
  }) {
    final valueChangeNotifier = ValueChangeNotifer<Q>(initialValue);
    final widget = ValueChangeNotifierBuilder(
      builder: builder,
      valueChangeNotifier: valueChangeNotifier,
    );
    if (onInit != null) {
      onInit(valueChangeNotifier);
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueChangeNotifier,
      builder: (context, value, child) {
        return builder(
          context,
          value,
          (value) {
            valueChangeNotifier.value = value;
          },
          child,
        );
      },
    );
  }
}
