import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Consistent card wrapper (icon + title header, then content) shared by
/// every section on the settings page, so adding a new section only means
/// wrapping its content in one of these rather than restyling by hand.
class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    required this.title,
    required this.icon,
    required this.child,
    super.key,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            child,
          ],
        ),
      ),
    );
  }
}
