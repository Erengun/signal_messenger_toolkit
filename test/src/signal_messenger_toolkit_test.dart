// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:signal_messenger_toolkit/signal_messenger_toolkit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Initialize binding

  group('SignalMessengerToolkit', () {
    test('can be instantiated', () {
      expect(SignalMessengerToolkit(), isNotNull);
    });

    test('createStickerPack throws ArgumentError when imagePaths and emojis lengths differ', () async {
      final toolkit = SignalMessengerToolkit();
      expect(
        () async => toolkit.createStickerPack(
          title: 'Test Pack',
          author: 'Test Author',
          imagePaths: ['image1.png'],
          emojis: ['😀', '😁'],
          outputPath: 'output',
        ),
        throwsArgumentError,
      );
    });

    test('createStickerPack completes successfully with valid inputs', () async {
      final toolkit = SignalMessengerToolkit();
      final tempDir = await Directory.systemTemp.createTemp('test_smtk');
      final imagePath = '${tempDir.path}/image1.png';
      await File(imagePath).writeAsBytes(List.generate(512 * 512 * 4, (i) => 255)); // Mock image data

      final outputFile = await toolkit.createStickerPack(
        title: 'Test Pack',
        author: 'Test Author',
        imagePaths: [imagePath],
        emojis: ['😀'],
        outputPath: '${tempDir.path}/output',
      );

      expect(outputFile.existsSync(), isTrue);
      expect(outputFile.path.endsWith('.tar.gz'), isTrue);

      await tempDir.delete(recursive: true);
    });
  });
}
