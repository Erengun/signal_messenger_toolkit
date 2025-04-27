import 'dart:io';

import 'package:signal_messenger_toolkit/src/pack_meta.dart';
import 'package:signal_messenger_toolkit/src/sticker_meta.dart';
import 'package:signal_messenger_toolkit/src/utils/sticker_utils.dart';

/// {@template signal_messenger_toolkit}
/// signal_messenger_toolkit is an unofficial Flutter toolkit for integrating
/// with the Signal platform—built by the community and not officially endorsed
/// by Signal
/// {@endtemplate}
class SignalMessengerToolkit {
  /// {@macro signal_messenger_toolkit}
  const SignalMessengerToolkit();

  /// Creates a sticker pack archive from a list of images and emojis.
  ///
  /// This function takes the provided images and emojis, creates a temporary
  /// workspace, copies the images, generates a `stickers.yaml` file with metadata,
  /// and compresses the entire pack into a `.tar.gz` file.
  ///
  /// Throws an [ArgumentError] if the lengths of [imagePaths] and [emojis]
  /// do not match.
  ///
  /// Returns the created `.tar.gz` archive file.
  ///
  /// Parameters:
  /// - [title]: The title of the sticker pack.
  /// - [author]: The author of the sticker pack.
  /// - [imagePaths]: A list of paths to the images to be included in the pack.
  /// - [emojis]: A list of emojis corresponding to each image.
  /// - [outputPath]: The output path prefix for the archive (without the `.tar.gz` extension).

  Future<File> createStickerPack({
    required String title,
    required String author,
    required List<String> imagePaths,
    required List<String> emojis,
    required String outputPath, // without “.tar.gz”
  }) async {
    if (imagePaths.length != emojis.length) {
      throw ArgumentError('images and emojis length mismatch');
    }

    // 1. temp workspace
    final tmp = await Directory.systemTemp.createTemp('smtk_pack');

    // 2. copy raw images
    await copyStickers(imagePaths, tmp);

    // 3. write stickers.yaml
    final meta = PackMeta(
      title: title,
      author: author,
      stickers: [
        for (var i = 0; i < imagePaths.length; i++)
          StickerMeta(
            emoji: emojis[i],
            fileName: File(imagePaths[i]).uri.pathSegments.last,
          ),
      ],
    );
    await File('${tmp.path}/stickers.yaml').writeAsString(generateYaml(meta));

    // 4. tar + gzip
    final gz = await createTarGz(tmp, outputPath);

    await tmp.delete(recursive: true);
    return gz;
  }
}
