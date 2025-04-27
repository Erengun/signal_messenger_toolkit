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


  /// High-level API: creates a Signal sticker pack archive.
  ///
  /// - [title], [author]: pack info
  /// - [imagePaths]: source image file paths
  /// - [emojis]: one emoji per image
  /// - [outputPath]: path prefix for `.tar.gz` (omit extension)
  ///
  /// Returns the final `.tar.gz` file.
  Future<File> createStickerPack({
    required String title,
    required String author,
    required List<String> imagePaths,
    required List<String> emojis,
    required String outputPath,
  }) async {
    if (imagePaths.length != emojis.length) {
      throw ArgumentError('Each image needs an associated emoji.');
    }

    // 1. Prepare temp directory
    final tmp = await Directory.systemTemp.createTemp('smtk');

    // 2. Process each image
    final metas = <StickerMeta>[];
    for (var i = 0; i < imagePaths.length; i++) {
      // Crop
      final cropped = await cropImage(imagePaths[i]);
      if (cropped == null) continue;

      // Compress
      final webpData = await compressToWebP(cropped.path);
      if (webpData == null) continue;

      // Save as stickerX.webp
      final fileName = 'sticker${i + 1}.webp';
      final file = File('${tmp.path}/$fileName');
      await file.writeAsBytes(webpData);

      metas.add(StickerMeta(emoji: emojis[i], fileName: fileName));
    }

    // 3. Create stickers.yaml
    final packMeta = PackMeta(title: title, author: author, stickers: metas);
    final yamlString = generateYaml(packMeta);
    await File('${tmp.path}/stickers.yaml').writeAsString(yamlString);

    // 4. Tar+Gzip
    final gz = await createTarGz(tmp, outputPath);

    // 5. Cleanup
    await tmp.delete(recursive: true);
    return gz;
  }
}
