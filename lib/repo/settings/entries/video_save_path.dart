import 'dart:io';

import 'package:oscillo_ui/repo/settings/entries/base_entry.dart';

class VideoSavePath extends BaseEntry {
  VideoSavePath._internal()
      : super(
          key: 'video_save_path',
          defaultValue: '/videos',
          title: 'Video Save Path',
          description: 'Enter the path to save videos',
        );

  static final VideoSavePath _instance = VideoSavePath._internal();

  factory VideoSavePath() => _instance;

  @override
  Future<bool> get isEnabled async {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
}