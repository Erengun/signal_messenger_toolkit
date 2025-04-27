// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signal_messenger_toolkit/signal_messenger_toolkit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('createStickerPack builds valid archive with one sticker', () async {
    // tiny 1×1 transparent PNG
    final bytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAEUlEQVR42mP8'
      '/5+hHgAHggJ/Pj2MKwAAAABJRU5ErkJggg==',
    );
    final tmpDir  = await Directory.systemTemp.createTemp('smtk_png');
    final imgFile = File('${tmpDir.path}/tiny.png')..writeAsBytesSync(bytes);

    final gz = await SignalMessengerToolkit().createStickerPack(
      title: 'Pixel',
      author: 'Tester',
      imagePaths: [imgFile.path],
      emojis: ['🙂'],
      outputPath: '${tmpDir.path}/pack',
    );

    expect(gz.existsSync(), isTrue);

    final tarBytes   = GZipDecoder().decodeBytes(gz.readAsBytesSync());
    final tarArchive = TarDecoder().decodeBytes(tarBytes);
    expect(
      tarArchive.files.map((e) => e.name),
      containsAll(['stickers.yaml', 'tiny.png']),
    );

    await tmpDir.delete(recursive: true);
  });
}
