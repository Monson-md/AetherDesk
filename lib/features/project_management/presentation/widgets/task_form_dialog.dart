import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_task.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/due_date_field.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/priority_widgets.dart';
import 'package:flutter/material.dart';

/// Result of a submitted [TaskFormDialog]: the raw field values, ready to
/// hand to `ProjectManagementController.addTask` or `.updateTaskDetails`.
class TaskFormResult {
  const TaskFormResult({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  });

  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;
}

/// Create/edit form for a [ProjectTask]. Pass [task] to pre-fill it for
/// editing; omit it to create a new one.
class TaskFormDialog extends StatefulWidget {
  const TaskFormDialog({this.task, super.key});

  final ProjectTask? task;

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  late final _titleController = TextEditingController(text: widget.task?.title);
  late final _descriptionController = TextEditingController(
    text: widget.task?.description,
  );
  late TaskPriority _priority = widget.task?.priority ?? TaskPriority.medium;
  late DateTime? _dueDate = widget.task?.dueDate;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_handleTitleChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleTitleChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.task != null;

    return AlertDialog(
      title: Text(
        isEditing
            ? l10n.projectManagementEditTaskTitle
            : l10n.projectManagementNewTask,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: l10n.projectManagementTaskTitleLabel,
              controller: _titleController,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            AppTextField(
              label: l10n.projectManagementDescriptionLabel,
              controller: _descriptionController,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            PrioritySelector(
              value: _priority,
              onChanged: (value) => setState(() => _priority = value),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            DueDateField(
              value: _dueDate,
              onChanged: (value) => setState(() => _dueDate = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _titleController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  TaskFormResult(
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim().isEmpty
                        ? null
                        : _descriptionController.text.trim(),
                    priority: _priority,
                    dueDate: _dueDate,
                  ),
                ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
