import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/widgets/layout/responsive_content_wrapper.dart';
import 'package:flutter/material.dart';

/// Shared "this module is under construction" screen.
///
/// Every feature module's home page renders this — tinted with the
/// module's own [accentColor] from `nav_destinations.dart` — until its real
/// UI is built, so navigating between modules is fully functional and
/// visually polished today even though no business logic exists yet.
class ModulePlaceholderPage extends StatelessWidget {
  const ModulePlaceholderPage({
    required this.title,
    required this.comingSoonTitle,
    required this.comingSoonMessage,
    required this.icon,
    required this.accentColor,
    super.key,
  });

  final String title;
  final String comingSoonTitle;
  final String comingSoonMessage;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ResponsiveContentWrapper(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingLg),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: accentColor),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMd,
                    vertical: AppDimensions.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: Text(
                    comingSoonTitle,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Text(
                  comingSoonMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
