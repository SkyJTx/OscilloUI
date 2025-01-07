import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oscillo_ui/component/value_change_notifier/value_change_notifier.dart';
import 'package:oscillo_ui/page/main_page/main_page.dart';
import 'package:oscillo_ui/page/settings_page/settings_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final ValueChangeNotifer<int?> navigationPaneSelector = ValueChangeNotifer(null);

  @override
  Widget build(BuildContext context) {
    return ValueChangeNotifierBuilder<int?>(
      valueChangeNotifier: navigationPaneSelector,
      builder: (context, value, setValue) {
        return NavigationView(
          appBar: NavigationAppBar(
            title: Text(AppLocalizations.of(context)!.title),
          ),
          pane: NavigationPane(
            selected: value,
            onChanged: setValue,
            onItemPressed: setValue,
            items: [
              PaneItem(
                icon: Icon(Icons.home),
                title: Text(AppLocalizations.of(context)!.homeNavigationPaneTitle),
                body: MainPage(),
              ),
              PaneItem(
                icon: Icon(Icons.settings),
                title: Text(AppLocalizations.of(context)!.settingsNavigationPaneTitle),
                body: SettingsPage(),
              ),
            ],
          ),
        );
      },
    );
  }
}
