/// Centralized asset paths.
///
/// Referencing assets through this class instead of raw string literals
/// means a renamed or moved file only needs to be updated in one place, and
/// typos become compile-time errors caught by the analyzer at usage sites.
abstract final class AppAssets {
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _animationsPath = 'assets/animations';

  // Example placeholders — replace with real filenames once assets exist.
  static const String logo = '$_imagesPath/logo.png';
  static const String placeholder = '$_imagesPath/placeholder.png';
  static const String appIcon = '$_iconsPath/app_icon.png';
  static const String splashAnimation = '$_animationsPath/splash.json';
}
