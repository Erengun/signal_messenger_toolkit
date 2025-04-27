import 'package:signal_messenger_toolkit/src/sticker_meta.dart';

/// Metadata for the entire pack.
/// Metadata for the entire pack.
class PackMeta {
  /// Creates a new [PackMeta] instance.
  const PackMeta({
    required this.title,
    required this.author,
    required this.stickers,
  });

  /// The title of the sticker pack.
  final String title;

  /// The author of the sticker pack.
  final String author;

  /// The list of stickers in the pack.
  final List<StickerMeta> stickers;
}
