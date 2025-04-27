import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:signal_messenger_toolkit/src/pack_meta.dart';
import 'package:yaml/yaml.dart';

/// Build YAML string for a sticker pack.
String generateYaml(PackMeta meta) {
  final map = {
    'title': meta.title,
    'author': meta.author,
    'stickers': meta.stickers
        .map((s) => {'emoji': s.emoji, 'file': s.fileName})
        .toList(),
  };
  // yaml package can't dump straight from Map, so JSON→YAML trick
  return loadYaml(jsonEncode(map)).toString();
}

/// Copy every file in [paths] into [targetDir]; names stay unchanged.
Future<void> copyStickers(
  List<String> paths,
  Directory targetDir,
) async {
  for (final p in paths) {
    final src = File(p);
    if (!src.existsSync()) {
      throw FileSystemException('Sticker file not found', p);
    }
    await src.copy('${targetDir.path}/${src.uri.pathSegments.last}');
  }
}

/// Tar then gzip everything inside [inputDir] → `<out>.tar.gz`.

Future<File> createTarGz(Directory inputDir, String outPrefix) async {
  final tarPath = '$outPrefix.tar';
  final encoder = TarFileEncoder()..create(tarPath);

  for (final entity in inputDir.listSync().whereType<File>()) {
    final entryName = entity.uri.pathSegments.last;  // e.g. "tiny.png" or "stickers.yaml"
    await encoder.addFile(entity, entryName);
  }
  await encoder.close();

  final tarBytes = File(tarPath).readAsBytesSync();
  final gzBytes  = const GZipEncoder().encode(tarBytes);
  final gzFile   = File('$outPrefix.tar.gz')..writeAsBytesSync(gzBytes);
  return gzFile;
}
