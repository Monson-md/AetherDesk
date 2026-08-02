import 'package:aetherdesk/core/constants/app_colors.dart';
import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Light `ThemeData` for AetherDesk. Kept in its own file (mirrored by
/// [darkTheme] in `dark_theme.dart`) so each palette can be tuned in
/// isolation as the design system matures.
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surfaceLight,
    foregroundColor: AppColors.textPrimaryLight,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: AppColors.surfaceLight,
    elevation: AppDimensions.elevationLow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
    ),
  ),
);
