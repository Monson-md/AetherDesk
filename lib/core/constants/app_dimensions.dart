/// Spacing, radius and elevation scale shared by every module.
///
/// Using a fixed scale instead of ad-hoc numbers keeps the UI consistent as
/// the app grows across many screens and contributors.
abstract final class AppDimensions {
  // Spacing
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // Border radius
  static const double radiusSm = 6;
  static const double radiusMd = 12;
  static const double radiusLg = 20;
  static const double radiusFull = 999;

  // Elevation
  static const double elevationLow = 1;
  static const double elevationMedium = 4;
  static const double elevationHigh = 8;

  // Layout
  static const double maxContentWidth = 1200;
  static const double navigationRailWidth = 240;
  static const double navigationRailCollapsedWidth = 72;
}
