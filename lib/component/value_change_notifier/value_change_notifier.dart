import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ValueChangeNotifer<T extends Object?> extends Cubit<T> {
  ValueChangeNotifer(super.state);

  T get value => state;

  set value(T value) => emit(value);
}

class ValueChangeNotifierBuilder<T extends Object?> extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    T value,
    void Function(T value) setValue,
  ) builder;

  final ValueChangeNotifer<T> valueChangeNotifer;

  const ValueChangeNotifierBuilder({
    super.key,
    required this.builder,
    required this.valueChangeNotifer,
  });

  static ValueChangeNotifierBuilder<Q> easy<Q extends Object?>({
    required Widget Function(
      BuildContext context,
      Q value,
      void Function(Q value) setValue,
    ) builder,
    required Q initialValue,
  }) {
    return ValueChangeNotifierBuilder(
      builder: builder,
      valueChangeNotifer: ValueChangeNotifer<Q>(initialValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValueChangeNotifer<T>, T>(
      bloc: valueChangeNotifer,
      builder: (context, value) {
        return builder(
          context,
          value,
          (value) {
            valueChangeNotifer.value = value;
          },
        );
      },
    );
  }
}

void t() {
  final widget = ValueChangeNotifierBuilder.easy<int>(
    initialValue: 0,
    builder: (context, value, setValue) {
      return Container(
        margin: EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          children: [
            Text('Value: $value'),
            ElevatedButton(
              onPressed: () {
                setValue(value + 1);
              },
              child: Text('Increment'),
            ),
          ],
        ),
      );
    },
  );
}
