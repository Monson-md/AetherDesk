import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_task.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_status.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/priority_widgets.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/task_status_widgets.dart';
import 'package:flutter/material.dart';

class _KanbanTaskRef {
  const _KanbanTaskRef({
    required this.projectId,
    required this.projectName,
    required this.task,
  });

  final String projectId;
  final String projectName;
  final ProjectTask task;
}

/// Three-column board (todo / in progress / done) flattening every task
/// across [projects] into draggable cards. Dropping a card on another
/// column calls [onStatusChanged] to move it there — the only mutation this
/// view performs; task/project editing still happens on their own pages.
class KanbanBoardView extends StatelessWidget {
  const KanbanBoardView({
    required this.projects,
    required this.onStatusChanged,
    super.key,
  });

  final List<Project> projects;
  final void Function(String projectId, String taskId, TaskStatus status)
  onStatusChanged;

  List<_KanbanTaskRef> _tasksFor(TaskStatus status) {
    final refs = <_KanbanTaskRef>[];
    for (final project in projects) {
      for (final task in project.tasks) {
        if (task.status == status) {
          refs.add(
            _KanbanTaskRef(
              projectId: project.id,
              projectName: project.name,
              task: task,
            ),
          );
        }
      }
    }
    return refs;
  }

  @override
  Widget build(BuildContext context) {
    if (projects.every((project) => project.tasks.isEmpty)) {
      final l10n = AppLocalizations.of(context)!;
      return EmptyStateWidget(
        icon: Icons.view_column_outlined,
        title: l10n.projectManagementNoTasksYet,
        message: l10n.projectManagementNoTasksYet,
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: TaskStatus.values
            .map(
              (status) => _KanbanColumn(
                status: status,
                tasks: _tasksFor(status),
                onStatusChanged: onStatusChanged,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  const _KanbanColumn({
    required this.status,
    required this.tasks,
    required this.onStatusChanged,
  });

  final TaskStatus status;
  final List<_KanbanTaskRef> tasks;
  final void Function(String projectId, String taskId, TaskStatus status)
  onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return DragTarget<_KanbanTaskRef>(
      onWillAcceptWithDetails: (details) => details.data.task.status != status,
      onAcceptWithDetails: (details) =>
          onStatusChanged(details.data.projectId, details.data.task.id, status),
      builder: (context, candidateData, rejectedData) {
        final isTargeted = candidateData.isNotEmpty;
        return Container(
          width: 280,
          margin: const EdgeInsets.only(right: AppDimensions.spacingMd),
          padding: const EdgeInsets.all(AppDimensions.spacingSm),
          decoration: BoxDecoration(
            color: isTargeted
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: isTargeted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingXs,
                  vertical: AppDimensions.spacingXs,
                ),
                child: Row(
                  children: [
                    Icon(
                      status.icon,
                      size: 18,
                      color: status.color(theme.colorScheme),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(status.label(l10n), style: theme.textTheme.titleSmall),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(
                      '${tasks.length}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 560),
                child: ListView(
                  shrinkWrap: true,
                  children: tasks
                      .map(
                        (ref) => _KanbanCard(
                          taskRef: ref,
                          onStatusChanged: onStatusChanged,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KanbanCard extends StatelessWidget {
  const _KanbanCard({required this.taskRef, required this.onStatusChanged});

  final _KanbanTaskRef taskRef;
  final void Function(String projectId, String taskId, TaskStatus status)
  onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final content = Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingSm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskRef.task.title,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              taskRef.projectName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriorityBadge(priority: taskRef.task.priority),
                TaskStatusControl(
                  status: taskRef.task.status,
                  onChanged: (status) => onStatusChanged(
                    taskRef.projectId,
                    taskRef.task.id,
                    status,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Draggable<_KanbanTaskRef>(
      data: taskRef,
      feedback: Material(
        elevation: AppDimensions.elevationHigh,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: SizedBox(width: 260, child: content),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: content),
      child: content,
    );
  }
}
