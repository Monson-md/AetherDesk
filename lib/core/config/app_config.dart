import 'package:aetherdesk/core/config/env_config.dart';

/// Static application metadata, independent of environment.
///
/// Version numbers are duplicated from `pubspec.yaml` on purpose: reading
/// them at runtime would require the `package_info_plus` plugin, which is
/// out of scope until the app actually needs it (e.g. an "About" screen).
abstract final class AppConfig {
  static const String appName = 'AetherDesk';
  static const String version = '1.0.0';

  /// Active environment for the current build. Defaults to [Environment.dev]
  /// until build flavors are wired up in CI.
  static const Environment environment = Environment.dev;
}
