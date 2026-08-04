import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:flutter/material.dart';

/// Maps [TaskPriority] to a localized label and a theme color, kept in the
/// presentation layer since `domain/entities/` must stay Flutter-free.
extension TaskPriorityPresentation on TaskPriority {
  String label(AppLocalizations l10n) => switch (this) {
    TaskPriority.low => l10n.projectManagementPriorityLow,
    TaskPriority.medium => l10n.projectManagementPriorityMedium,
    TaskPriority.high => l10n.projectManagementPriorityHigh,
    TaskPriority.urgent => l10n.projectManagementPriorityUrgent,
  };

  Color color(ColorScheme colorScheme) => switch (this) {
    TaskPriority.low => colorScheme.onSurfaceVariant,
    TaskPriority.medium => colorScheme.primary,
    TaskPriority.high => colorScheme.tertiary,
    TaskPriority.urgent => colorScheme.error,
  };
}

/// Small colored pill showing a [TaskPriority]'s localized label — used on
/// project cards and task tiles.
class PriorityBadge extends StatelessWidget {
  const PriorityBadge({required this.priority, super.key});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = priority.color(Theme.of(context).colorScheme);
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
        priority.label(l10n),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Segmented control for picking a [TaskPriority] in the project/task forms.
class PrioritySelector extends StatelessWidget {
  const PrioritySelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TaskPriority value;
  final ValueChanged<TaskPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SegmentedButton<TaskPriority>(
      segments: TaskPriority.values
          .map(
            (priority) => ButtonSegment(
              value: priority,
              label: Text(priority.label(l10n)),
            ),
          )
          .toList(),
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
