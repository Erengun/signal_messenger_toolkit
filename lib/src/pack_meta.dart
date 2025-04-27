import 'package:signal_messenger_toolkit/src/sticker_meta.dart';

/// Metadata for the entire pack.
class PackMeta {
  const PackMeta({
    required this.title,
    required this.author,
    required this.stickers,
  });
  final String title;
  final String author;
  final List<StickerMeta> stickers;
}
