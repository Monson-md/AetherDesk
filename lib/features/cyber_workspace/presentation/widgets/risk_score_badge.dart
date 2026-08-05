import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Colored pill showing a simulated 0-100 risk score: low scores read as
/// safe (tertiary), high scores as risky (error), consistent with how
/// `PriorityBadge` maps a domain value to a `ColorScheme` role.
class RiskScoreBadge extends StatelessWidget {
  const RiskScoreBadge({required this.score, super.key});

  final int score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final color = score >= 70
        ? colorScheme.error
        : score >= 40
        ? colorScheme.tertiary
        : colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        l10n.cyberWorkspaceRiskScore(score),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
