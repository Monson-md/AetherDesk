import 'dart:io';

import 'package:flutter/material.dart';

/// Curated set of icons offered for the locally-customizable avatar,
/// used whenever the profile has no real photo (see [ProfileAvatar]).
const List<IconData> kProfileAvatarIcons = [
  Icons.person,
  Icons.face,
  Icons.pets,
  Icons.star,
  Icons.rocket_launch,
  Icons.emoji_nature,
  Icons.sports_esports,
  Icons.music_note,
  Icons.brush,
  Icons.code,
];

/// Circular avatar: a real photo (picked via `FileIoService` and stored in
/// the app's own private storage) when [photoPath] points to an existing
/// file, otherwise the profile's chosen icon on its chosen color.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.colorValue,
    required this.iconIndex,
    this.photoPath,
    this.radius = 40,
    super.key,
  });

  final int colorValue;
  final int iconIndex;
  final String? photoPath;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    if (path != null && File(path).existsSync()) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(File(path)),
      );
    }
    final icon = kProfileAvatarIcons[iconIndex % kProfileAvatarIcons.length];
    return CircleAvatar(
      radius: radius,
      backgroundColor: Color(colorValue),
      child: Icon(icon, color: Colors.white, size: radius),
    );
  }
}
