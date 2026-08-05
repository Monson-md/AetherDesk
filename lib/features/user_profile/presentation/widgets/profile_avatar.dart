import 'package:flutter/material.dart';

/// Curated set of icons offered for the locally-customizable avatar — this
/// app does no real disk I/O yet, so there is no real picture upload.
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

/// Circular avatar rendering the profile's chosen icon on its chosen color.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.colorValue,
    required this.iconIndex,
    this.radius = 40,
    super.key,
  });

  final int colorValue;
  final int iconIndex;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final icon = kProfileAvatarIcons[iconIndex % kProfileAvatarIcons.length];
    return CircleAvatar(
      radius: radius,
      backgroundColor: Color(colorValue),
      child: Icon(icon, color: Colors.white, size: radius),
    );
  }
}
