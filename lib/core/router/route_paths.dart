/// Every route path in the app, defined once so a typo becomes a
/// compile-time error instead of a runtime 404.
abstract final class RoutePaths {
  static const String dashboard = '/';
  static const String aiAssistant = '/ai-assistant';
  static const String codeEditor = '/code-editor';
  static const String projectManagement = '/projects';
  static const String secureVault = '/vault';
  static const String cyberWorkspace = '/cyber-workspace';
  static const String creation2d = '/creation-2d';
  static const String creation3d = '/creation-3d';
  static const String settings = '/settings';
  static const String userProfile = '/profile';
}
