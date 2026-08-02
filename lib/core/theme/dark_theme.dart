import 'package:aetherdesk/core/constants/app_colors.dart';
import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Dark `ThemeData` for AetherDesk. See `light_theme.dart` for context.
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surfaceDark,
    foregroundColor: AppColors.textPrimaryDark,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: AppColors.surfaceDark,
    elevation: AppDimensions.elevationLow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
    ),
  ),
);
