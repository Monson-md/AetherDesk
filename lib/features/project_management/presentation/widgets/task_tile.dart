import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/project_management/domain/entities/checklist_item.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_task.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/add_checklist_item_field.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/checklist_item_row.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/priority_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Expandable tile for one [ProjectTask]: done checkbox, priority/due-date
/// badges, edit/delete actions, and its checklist.
class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.onToggleDone,
    required this.onEdit,
    required this.onDelete,
    required this.onAddChecklistItem,
    required this.onToggleChecklistItem,
    required this.onDeleteChecklistItem,
    super.key,
  });

  final ProjectTask task;
  final ValueChanged<bool> onToggleDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<String> onAddChecklistItem;
  final void Function(ChecklistItem item, bool isDone) onToggleChecklistItem;
  final ValueChanged<ChecklistItem> onDeleteChecklistItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: ExpansionTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (checked) => onToggleDone(checked ?? false),
        ),
        title: Text(
          task.title,
          style: theme.textTheme.titleSmall?.copyWith(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? theme.colorScheme.onSurfaceVariant : null,
          ),
        ),
        subtitle: Wrap(
          spacing: AppDimensions.spacingSm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            PriorityBadge(priority: task.priority),
            if (task.dueDate != null)
              Text(
                DateFormat.yMMMd().format(task.dueDate!),
                style: theme.textTheme.bodySmall,
              ),
            if (task.checklist.isNotEmpty)
              Text(
                '${task.completedChecklistCount}/${task.checklist.length}',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description != null && task.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.spacingSm,
                    ),
                    child: Text(
                      task.description!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                Text(
                  l10n.projectManagementChecklistTitle,
                  style: theme.textTheme.labelLarge,
                ),
                for (final item in task.checklist)
                  ChecklistItemRow(
                    item: item,
                    onToggle: (isDone) => onToggleChecklistItem(item, isDone),
                    onDelete: () => onDeleteChecklistItem(item),
                  ),
                AddChecklistItemField(onSubmit: onAddChecklistItem),
                const SizedBox(height: AppDimensions.spacingSm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
