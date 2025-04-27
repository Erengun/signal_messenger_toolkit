import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:signal_messenger_toolkit/src/pack_meta.dart';
import 'package:yaml/yaml.dart';


/// Serializes [meta] into a YAML string.
String generateYaml(PackMeta meta) {
  final map = {
    'title': meta.title,
    'author': meta.author,
    'stickers': meta.stickers
        .map((s) => {'emoji': s.emoji, 'file': s.fileName})
        .toList(),
  };
  // yaml package doesn't support dumping, so JSON → YAML hack
  final jsonString = jsonEncode(map);
  final yamlMap = loadYaml(jsonString) as YamlMap;
  return yamlMap.toString();
}

/// Compresses [inputPath] to WebP format (512×512 cap, ~≤300 KB).
Future<Uint8List?> compressToWebP(String inputPath) async {
  return FlutterImageCompress.compressWithFile(
    inputPath,
    format: CompressFormat.webp,
    minWidth: 512,
    minHeight: 512,
    quality: 80,
  );
}

/// Crops the image at [path] to a square 512×512 PNG.
Future<File?> cropImage(String path) async {
  final cropped = await ImageCropper().cropImage(
    sourcePath: path,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    maxWidth: 512,
    maxHeight: 512,
  );
  if (cropped == null) return null;
  return File(cropped.path);
}

/// Packages all files in [inputDir] into a gzipped TAR at [outputFile].
Future<File> createTarGz(Directory inputDir, String outputFile) async {
  final tarPath = '$outputFile.tar';
  final tarEncoder = TarFileEncoder()..create(tarPath);
  for (final entity in inputDir.listSync()) {
    if (entity is File) {
      await tarEncoder.addFile(entity);
    }
  }
  await tarEncoder.close();

  final tarBytes = File(tarPath).readAsBytesSync();
  final gzBytes = const GZipEncoder().encode(tarBytes);
  final gzFile = File('$outputFile.tar.gz')..writeAsBytesSync(gzBytes);
  return gzFile;
}
