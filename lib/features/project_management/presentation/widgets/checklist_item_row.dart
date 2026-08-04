import 'package:aetherdesk/features/project_management/domain/entities/checklist_item.dart';
import 'package:flutter/material.dart';

/// A single checkable line inside a task's checklist: checkbox, label with
/// a strikethrough once done, and a delete action.
class ChecklistItemRow extends StatelessWidget {
  const ChecklistItemRow({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final ChecklistItem item;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Checkbox(
          value: item.isDone,
          onChanged: (checked) => onToggle(checked ?? false),
        ),
        Expanded(
          child: Text(
            item.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              decoration: item.isDone ? TextDecoration.lineThrough : null,
              color: item.isDone ? theme.colorScheme.onSurfaceVariant : null,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
