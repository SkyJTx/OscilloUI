import 'dart:io';

import 'package:gal/gal.dart';
import 'package:opencv_dart/opencv.dart' as cv;
import 'package:oscillo_ui/component/errors/error_base.dart';
import 'package:oscillo_ui/constant/oscilloscope.dart';
import 'package:oscillo_ui/repo/settings/settings_repo.dart';
import 'package:path_provider/path_provider.dart';

class VideoRepo {
  static const videoAlbumName = 'Oscilloscope_Video';

  VideoRepo._privateConstructor();

  static final VideoRepo _instance = VideoRepo._privateConstructor();

  factory VideoRepo() {
    return _instance;
  }

  Future<void> saveVideo(
    List<ImageByteWithTimestamp> video, {
    String? name,
    int framerate = 30,
  }) async {
    final fileName = name ?? 'capture_${DateTime.now().millisecondsSinceEpoch}';
    final tempDirectory = await getTemporaryDirectory();
    final tempVideoPath = '${tempDirectory.path}/$fileName.mp4';
    String tempImagePath(int i) => '${tempDirectory.path}/$fileName-$i.png';

    if (video.length < 2) {
      throw RequestError(
        error: 'Video must have at least 2 frames',
      );
    }

    try {
      for (var i = 0; i < video.length; i++) {
        final image = video[i].image;
        final file = File(tempImagePath(i));
        await file.writeAsBytes(image);
      }
    } on ErrorBase {
      rethrow;
    } catch (e, s) {
      throw UnknownError(
        error: e,
        stackTrace: s,
      );
    }

    try {
      final mats = [
        for (var i = 0; i < video.length; i++)
          (
            timestamp: video[i].timestamp,
            image: cv.imread(tempImagePath(i)),
          ),
      ];

      final videoWriter = cv.VideoWriter.empty();
      videoWriter.open(
        tempVideoPath,
        'mp4v',
        framerate.toDouble(),
        (640, 480),
      );

      for (var i = 0; i < mats.length - 1; i++) {
        final mat = mats[i];
        final nextMat = mats[i + 1];

        final diff = nextMat.timestamp.difference(mat.timestamp).inMilliseconds;

        for (double j = 0; j < diff; j = j + 1000 / framerate) {
          videoWriter.write(mat.image);
        }
      }

      final averageDiff =
          mats.last.timestamp.difference(mats.first.timestamp).inMilliseconds / (mats.length - 1);
      for (double k = 0; k < averageDiff; k = k + 1000 / framerate) {
        videoWriter.write(mats.last.image);
      }

      videoWriter.release();

      for (var i = 0; i < video.length; i++) {
        final file = File(tempImagePath(i));
        await file.delete();
      }
    } on ErrorBase {
      rethrow;
    } catch (e, s) {
      throw UnknownError(
        error: e,
        stackTrace: s,
      );
    }

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        final videoSavePath = await SettingsRepo().videoSavePath.value;
        final path = '$videoSavePath/$name.mp4';
        final file = File(tempVideoPath);
        await file.copy(path);
      } on ErrorBase {
        rethrow;
      } catch (e, s) {
        throw UnknownError(
          error: e,
          stackTrace: s,
        );
      } finally {
        final file = File(tempVideoPath);
        await file.delete();
      }
    } else if (Platform.isAndroid || Platform.isIOS) {
      try {
        final hasAccess = await Gal.requestAccess(toAlbum: true);
        if (hasAccess) {
          await Gal.putVideo(
            tempVideoPath,
            album: videoAlbumName,
          );
        } else {
          throw PermissionDeniedError();
        }
      } on GalException catch (e) {
        throw UnknownError(
          error: e.type.message,
          stackTrace: e.stackTrace,
        );
      } finally {
        final file = File(tempVideoPath);
        await file.delete();
      }
    } else {
      throw UnsupportedPlatformError(
        error: Platform.operatingSystem,
      );
    }
  }
}
