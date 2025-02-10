import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:oscillo_ui/component/errors/error_base.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';

class ImageRepo {
  static const imageAlbumName = 'Oscilloscope_Image';

  ImageRepo._privateConstructor();

  static final ImageRepo _instance = ImageRepo._privateConstructor();

  factory ImageRepo() {
    return _instance;
  }

  Future<void> saveImage(Uint8List image, {String? name}) async {
    final fileName = name ?? 'capture_${DateTime.now().millisecondsSinceEpoch}';
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        final savePath = await SettingsRepo().imageSavePath.value;
        final path = '$savePath/$name.png';
        final file = await File(path).create(recursive: true);
        await file.writeAsBytes(image);
      } catch (e, s) {
        throw UnknownError(
          error: e.toString(),
          stackTrace: s,
        );
      }
    } else if (Platform.isAndroid || Platform.isIOS) {
      try {
        final hasAccess = await Gal.requestAccess(toAlbum: true);
        if (hasAccess) {
          await Gal.putImageBytes(
            image,
            album: imageAlbumName,
            name: fileName,
          );
        } else {
          throw PermissionDeniedError();
        }
      } on GalException catch (e) {
        throw UnknownError(
          error: e.type.message,
          stackTrace: e.stackTrace,
        );
      }
      throw UnsupportedPlatformError();
    } else {
      throw UnsupportedPlatformError();
    }
  }
}
