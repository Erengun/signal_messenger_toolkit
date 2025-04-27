import 'package:signal_messenger_toolkit/src/sticker_meta.dart';

/// Metadata for the entire pack.
class PackMeta {
  final String title;
  final String author;
  final List<StickerMeta> stickers;
  PackMeta({
    required this.title,
    required this.author,
    required this.stickers,
  });
}
