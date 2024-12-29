import 'dart:io';

import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class ImageSavePath extends BaseEntry {
  ImageSavePath._internal()
      : super(
          key: 'image_save_path',
          defaultValue: '/images',
          title: 'Image Save Path',
          description: 'Enter the path to save images',
        );

  static final ImageSavePath _instance = ImageSavePath._internal();

  factory ImageSavePath() => _instance;

  @override
  Future<bool> get isEnabled async {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
}