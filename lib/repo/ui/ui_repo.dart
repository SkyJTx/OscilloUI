import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oscillo_ui/page/main_page/main_page.dart';

class UiRepo {
  static final UiRepo _instance = UiRepo._internal();

  factory UiRepo() => _instance;

  UiRepo._internal();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static NavigatorState get navigator => navigatorKey.currentState!;
  static ScaffoldMessengerState get scaffoldMessenger => scaffoldMessengerKey.currentState!;

  final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: MainPage.routeName,
    routes: [
      ShellRoute(
        pageBuilder: (context, state, child) {
          return MaterialPage(
            key: state.pageKey,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: MainPage.routeName,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: MainPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
