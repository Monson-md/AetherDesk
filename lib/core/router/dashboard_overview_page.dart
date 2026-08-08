import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Landing screen at [RoutePaths.dashboard]. Not a feature module of its
/// own — it's the entry point of the navigation shell, presenting the 9
/// modules as a grid so the app is fully navigable before any module has
/// real business logic. A [ConsumerWidget] so it is ready to `ref.watch`
/// real providers (recent projects, notifications...) once modules exist.
class DashboardOverviewPage extends ConsumerWidget {
  const DashboardOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final destinations = buildNavDestinations(l10n);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDashboard)),
      body: ResponsiveContentWrapper(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                '${destinations.length} modules',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: AppDimensions.spacingMd,
                    crossAxisSpacing: AppDimensions.spacingMd,
                  ),
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final destination = destinations[index];
                    return _ModuleCard(
                      destination: destination,
                      statusLabel: switch (destination.status) {
                        ModuleStatus.comingSoon => l10n.comingSoonTitle,
                        ModuleStatus.inProgress =>
                          l10n.moduleStatusInProgressLabel,
                        ModuleStatus.available =>
                          l10n.moduleStatusAvailableLabel,
                      },
                      onTap: () => context.go(destination.path),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.destination,
    required this.statusLabel,
    required this.onTap,
  });

  final AppNavDestination destination;
  final String statusLabel;
  final VoidCallback onTap;

  static const _availableColor = Color(0xFF22C55E);
  static const _inProgressColor = Color(0xFFC9962B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = switch (destination.status) {
      ModuleStatus.available => _availableColor,
      ModuleStatus.inProgress => _inProgressColor,
      ModuleStatus.comingSoon => theme.colorScheme.outline,
    };
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingSm),
                decoration: BoxDecoration(
                  color: destination.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  destination.icon,
                  size: 28,
                  color: destination.color,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                destination.label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingSm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  statusLabel,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
