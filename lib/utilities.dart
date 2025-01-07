extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension ComparableList on List<Comparable> {
  List<Comparable> sorted() {
    return List.from(this)..sort();
  }

  Comparable max<T extends Comparable>() {
    if (isEmpty) {
      throw StateError('List is empty');
    }
    Comparable max = this[0];
    for (final element in this) {
      if (element.compareTo(max) > 0) {
        max = element;
      }
    }

    return max;
  }

  Comparable min<T extends Comparable>() {
    if (isEmpty) {
      throw StateError('List is empty');
    }
    Comparable min = this[0];
    for (final element in this) {
      if (element.compareTo(min) < 0) {
        min = element;
      }
    }

    return min;
  }
}