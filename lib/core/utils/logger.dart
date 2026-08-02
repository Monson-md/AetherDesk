import 'dart:developer' as developer;

import 'package:aetherdesk/core/constants/app_strings.dart';

/// Thin wrapper around `dart:developer.log` so call sites don't hardcode a
/// log tag and so the underlying logging mechanism can be swapped (e.g. for
/// a remote logging service) in one place later.
abstract final class AppLogger {
  static void debug(String message) => _log(message, level: 500);

  static void info(String message) => _log(message, level: 800);

  static void warning(String message) => _log(message, level: 900);

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: AppStrings.logTag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _log(String message, {required int level}) {
    developer.log(message, name: AppStrings.logTag, level: level);
  }
}
