/// Descriptor for a single sticker.
///
/// This represents a single sticker in the sticker pack.
///
/// The [emoji] should be a single emoji character that represents the sticker,
/// and the [fileName] should be the name of the file that contains the sticker
/// image.
class StickerMeta {
  /// Create a [StickerMeta].
  ///
  /// The [emoji] should be a single emoji character that represents the sticker,
  /// and the [fileName] should be the name of the file that contains the sticker
  /// image.
  const StickerMeta({required this.emoji, required this.fileName});

  /// A single emoji character that represents the sticker.
  final String emoji;

  /// The name of the file that contains the sticker image.
  final String fileName;
}
