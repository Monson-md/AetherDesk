import 'package:flutter/material.dart';

/// Central color palette for AetherDesk.
///
/// These are raw color values only. Do not reference them directly in UI
/// code — prefer `Theme.of(context).colorScheme` so light/dark mode and
/// future theming changes propagate automatically. This file is the single
/// place where the palette is defined and tuned.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF5B5FEF);
  static const Color primaryDark = Color(0xFF3F42B8);
  static const Color secondary = Color(0xFF00C2A8);

  // Neutrals
  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color backgroundDark = Color(0xFF101114);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1B1C21);

  // Semantic
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFE0424A);
  static const Color info = Color(0xFF3B9EFF);

  // Text
  static const Color textPrimaryLight = Color(0xFF1A1B1F);
  static const Color textSecondaryLight = Color(0xFF5B5D66);
  static const Color textPrimaryDark = Color(0xFFF2F2F5);
  static const Color textSecondaryDark = Color(0xFFA6A8B3);
}
