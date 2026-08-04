/// A user-defined grouping for [VaultItem]s, with a color the user picks
/// so folders stay visually distinguishable.
class VaultFolder {
  const VaultFolder({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  final String id;
  final String name;
  final int colorValue;
}
