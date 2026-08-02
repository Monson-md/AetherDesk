import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:flutter/material.dart';

/// One entry in the app's primary navigation. The rail, the drawer, the
/// dashboard grid, and each module's own placeholder page all read from
/// this same list — icon, label and accent color are defined exactly once
/// per module.
///
/// To add a new module later: add a path in [RoutePaths], add its l10n key
/// in `lib/l10n/*.arb`, add one entry below, create its
/// `presentation/pages/<module>_home_page.dart` using
/// `ModulePlaceholderPage` + [destinationFor], then register a `GoRoute` in
/// `app_router.dart`.
class AppNavDestination {
  const AppNavDestination({
    required this.path,
    required this.icon,
    required this.label,
    required this.color,
  });

  final String path;
  final IconData icon;
  final String label;
  final Color color;
}

List<AppNavDestination> buildNavDestinations(AppLocalizations l10n) => [
  AppNavDestination(
    path: RoutePaths.aiAssistant,
    icon: Icons.smart_toy_outlined,
    label: l10n.navAiAssistant,
    color: const Color(0xFF7C6FF0),
  ),
  AppNavDestination(
    path: RoutePaths.codeEditor,
    icon: Icons.code,
    label: l10n.navCodeEditor,
    color: const Color(0xFF00B8A9),
  ),
  AppNavDestination(
    path: RoutePaths.projectManagement,
    icon: Icons.folder_open_outlined,
    label: l10n.navProjectManagement,
    color: const Color(0xFF3B82F6),
  ),
  AppNavDestination(
    path: RoutePaths.secureVault,
    icon: Icons.lock_outline,
    label: l10n.navSecureVault,
    color: const Color(0xFFC9962B),
  ),
  AppNavDestination(
    path: RoutePaths.cyberWorkspace,
    icon: Icons.security_outlined,
    label: l10n.navCyberWorkspace,
    color: const Color(0xFF22C55E),
  ),
  AppNavDestination(
    path: RoutePaths.creation2d,
    icon: Icons.brush_outlined,
    label: l10n.navCreation2d,
    color: const Color(0xFFEC4899),
  ),
  AppNavDestination(
    path: RoutePaths.creation3d,
    icon: Icons.view_in_ar_outlined,
    label: l10n.navCreation3d,
    color: const Color(0xFF8B5CF6),
  ),
  AppNavDestination(
    path: RoutePaths.settings,
    icon: Icons.settings_outlined,
    label: l10n.navSettings,
    color: const Color(0xFF64748B),
  ),
  AppNavDestination(
    path: RoutePaths.userProfile,
    icon: Icons.person_outline,
    label: l10n.navUserProfile,
    color: const Color(0xFFF59E0B),
  ),
];

/// Looks up a single destination by route path, so a module's own page can
/// source its icon/label/color from the same list used by the shell instead
/// of duplicating them.
AppNavDestination destinationFor(AppLocalizations l10n, String path) {
  return buildNavDestinations(l10n).firstWhere((d) => d.path == path);
}
