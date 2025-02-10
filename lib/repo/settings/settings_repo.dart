import 'package:oscillo_ui/repo/database/database_repo.dart';
import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';
import 'package:oscillo_ui/repo/settings/entries/host_entry.dart';
import 'package:oscillo_ui/repo/settings/entries/image_save_path.dart';
import 'package:oscillo_ui/repo/settings/entries/locale_entry.dart';
import 'package:oscillo_ui/repo/settings/entries/port_entry.dart';
import 'package:oscillo_ui/repo/settings/entries/theme_entry.dart';
import 'package:oscillo_ui/repo/settings/entries/video_save_path.dart';

class SettingsRepo {
  static final storeRepo = StoreRepo();

  static final SettingsRepo instance = SettingsRepo._internal();

  SettingsRepo._internal();

  factory SettingsRepo() => instance;

  Future<void> init() async {
    await StoreRepo.create();
    await Future.wait(instance.entries.map(
      (entry) async {
        final rebaseEntry = await entry.rebase();
        return rebaseEntry.init();
      },
    ));
  }

  ThemeEntry get theme => ThemeEntry();

  LocaleEntry get locale => LocaleEntry();

  HostEntry get host => HostEntry();

  PortEntry get port => PortEntry();

  ImageSavePath get imageSavePath => ImageSavePath();

  VideoSavePath get videoSavePath => VideoSavePath();

  List<BaseEntry> get entries => [
        theme,
        locale,
        host,
        port,
        imageSavePath,
        videoSavePath,
      ];
}
