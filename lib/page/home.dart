import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oscillo_ui/component/value_change_notifier/value_change_notifier.dart';
import 'package:oscillo_ui/page/gallery_page/gallery_page.dart';
import 'package:oscillo_ui/page/main_page/main_page.dart';
import 'package:oscillo_ui/page/main_page/oscilloscope_cubit.dart';
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
    final locale = AppLocalizations.of(context);
    return ValueChangeNotifierBuilder<int?>(
      valueChangeNotifier: navigationPaneSelector,
      builder: (context, value, setValue, child) {
        return NavigationView(
          appBar: NavigationAppBar(
            title: Text(locale.title),
            actions: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Button(
                  child: Icon(FluentIcons.reset),
                  onPressed: () {
                    context.read<OscilloscopeCubit>().reset();
                  },
                ),
              ],
            ),
          ),
          pane: NavigationPane(
            selected: value,
            onChanged: setValue,
            onItemPressed: setValue,
            items: [
              PaneItem(
                icon: Icon(FluentIcons.home),
                title: Text(locale.homeNavigationPaneTitle),
                body: MainPage(),
              ),
              PaneItem(
                icon: Icon(FluentIcons.photo_collection),
                title: Text(locale.galleryNavigationPaneTitle),
                body: GalleryPage(),
              ),
            ],
            footerItems: [
              PaneItem(
                icon: Icon(FluentIcons.settings),
                title: Text(locale.settingsNavigationPaneTitle),
                body: SettingsPage(),
              ),
            ],
          ),
        );
      },
    );
  }
}
