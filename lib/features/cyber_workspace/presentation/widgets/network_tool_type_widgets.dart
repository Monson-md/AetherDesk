import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/network_tool_type.dart';
import 'package:flutter/material.dart';

/// Maps [NetworkToolType] to a localized label, an icon and a theme color,
/// kept in the presentation layer since `domain/entities/` must stay
/// Flutter-free. Colors reuse `ColorScheme` roles rather than introducing
/// new ad-hoc hex values, per the module accent-color convention.
extension NetworkToolTypePresentation on NetworkToolType {
  String label(AppLocalizations l10n) => switch (this) {
    NetworkToolType.ipAnalysis => l10n.cyberWorkspaceToolIpAnalysis,
    NetworkToolType.urlAnalysis => l10n.cyberWorkspaceToolUrlAnalysis,
    NetworkToolType.portScan => l10n.cyberWorkspaceToolPortScan,
    NetworkToolType.terminal => l10n.cyberWorkspaceToolTerminal,
  };

  IconData get icon => switch (this) {
    NetworkToolType.ipAnalysis => Icons.travel_explore_outlined,
    NetworkToolType.urlAnalysis => Icons.link_outlined,
    NetworkToolType.portScan => Icons.settings_ethernet_outlined,
    NetworkToolType.terminal => Icons.terminal_outlined,
  };

  Color color(ColorScheme colorScheme) => switch (this) {
    NetworkToolType.ipAnalysis => colorScheme.primary,
    NetworkToolType.urlAnalysis => colorScheme.tertiary,
    NetworkToolType.portScan => colorScheme.secondary,
    NetworkToolType.terminal => colorScheme.onSurfaceVariant,
  };
}
