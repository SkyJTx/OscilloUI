import 'package:flutter/material.dart';

class UiRepo {
  static final UiRepo _instance = UiRepo._internal();

  factory UiRepo() => _instance;

  UiRepo._internal();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigator => navigatorKey.currentState!;
}
