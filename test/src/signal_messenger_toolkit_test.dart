// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:signal_messenger_toolkit/signal_messenger_toolkit.dart';
import 'package:signal_messenger_toolkit/src/pack_meta.dart';
import 'package:signal_messenger_toolkit/src/sticker_meta.dart';
import 'package:signal_messenger_toolkit/src/utils/sticker_utils.dart';

void main() {
  // Ensures `flutter_test` is fully initialised.  ﹙Needed when testing code
  // that might rely on binding-level services later.﹚
  TestWidgetsFlutterBinding.ensureInitialized();
  

  group('Sticker utils', () {
    test('generateYaml produces the expected keys', () {
      final yaml = generateYaml(PackMeta(
        title: 'My Pack',
        author: 'Tester',
        stickers: [
          StickerMeta(emoji: '🙂', fileName: 's1.webp')
        ],
      ));
      expect(yaml, contains('title: My Pack'));
      expect(yaml, contains('author: Tester'));
      expect(yaml, contains('emoji: 🙂'));
    });

    test('createTarGz bundles files into a .tar.gz archive', () async {
      // 1. Create a temp dir + dummy file.
      final tempDir = await Directory.systemTemp.createTemp('smtk_test');
      final dummy = File('${tempDir.path}/hello.txt')..writeAsStringSync('hi');

      // 2. Archive it.
      final archive = await createTarGz(tempDir, '${tempDir.path}/out');

      // 3. Verify results.
      expect(archive.existsSync(), isTrue);
      expect(archive.path.endsWith('.tar.gz'), isTrue);
      expect(archive.lengthSync(), greaterThan(0));

      // 4. Clean-up.
      await tempDir.delete(recursive: true);
    });
  });

  group('createStickerPack', () {
    test('throws ArgumentError when images and emojis length mismatch', () {
      final tempDir = Directory.systemTemp.createTempSync('smtk_test_out');
      expect(
        SignalMessengerToolkit().createStickerPack(
          title: 'Err',
          author: 'Me',
          imagePaths: ['dummy.png'],   // only one
          emojis: ['🙂', '🙃'],         // two emojis → mismatch
          outputPath: '${tempDir.path}/pack',
        ),
        throwsA(isA<ArgumentError>()),   // expect a specific error type
      );
    });
  });
}
