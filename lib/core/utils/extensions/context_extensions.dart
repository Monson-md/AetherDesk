import 'package:flutter/material.dart';

/// Shorthand accessors used throughout the UI so widgets don't repeat
/// `Theme.of(context)` / `MediaQuery.of(context)` chains everywhere.
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textStyles => Theme.of(this).textTheme;

  Size get screenSize => MediaQuery.sizeOf(this);

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
