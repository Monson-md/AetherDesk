import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_status.dart';
import 'package:flutter/material.dart';

/// Maps [TaskStatus] to a localized label, an icon and a theme color, kept
/// in the presentation layer since `domain/entities/` must stay
/// Flutter-free.
extension TaskStatusPresentation on TaskStatus {
  String label(AppLocalizations l10n) => switch (this) {
    TaskStatus.todo => l10n.projectManagementStatusTodo,
    TaskStatus.inProgress => l10n.projectManagementStatusInProgress,
    TaskStatus.done => l10n.projectManagementStatusDone,
  };

  IconData get icon => switch (this) {
    TaskStatus.todo => Icons.radio_button_unchecked,
    TaskStatus.inProgress => Icons.incomplete_circle_outlined,
    TaskStatus.done => Icons.check_circle,
  };

  Color color(ColorScheme colorScheme) => switch (this) {
    TaskStatus.todo => colorScheme.onSurfaceVariant,
    TaskStatus.inProgress => colorScheme.primary,
    TaskStatus.done => colorScheme.tertiary,
  };
}

/// Popup menu button showing a [ProjectTask]'s current [TaskStatus] as an
/// icon, letting it be switched directly to any of the three states — used
/// by both `TaskTile` and the Kanban cards so status changes stay
/// consistent between views.
class TaskStatusControl extends StatelessWidget {
  const TaskStatusControl({
    required this.status,
    required this.onChanged,
    super.key,
  });

  final TaskStatus status;
  final ValueChanged<TaskStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<TaskStatus>(
      tooltip: status.label(l10n),
      onSelected: onChanged,
      itemBuilder: (context) => TaskStatus.values
          .map(
            (value) => PopupMenuItem(
              value: value,
              child: Row(
                children: [
                  Icon(value.icon, size: 18, color: value.color(colorScheme)),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Text(value.label(l10n)),
                ],
              ),
            ),
          )
          .toList(),
      child: Icon(status.icon, color: status.color(colorScheme)),
    );
  }
}
