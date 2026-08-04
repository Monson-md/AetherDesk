import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/category_widgets.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/due_date_field.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/priority_widgets.dart';
import 'package:flutter/material.dart';

/// Result of a submitted [ProjectFormDialog]: the raw field values, ready to
/// hand to `ProjectManagementController.createProject` or
/// `.updateProjectDetails`.
class ProjectFormResult {
  const ProjectFormResult({
    required this.name,
    required this.description,
    required this.categoryId,
    required this.priority,
    required this.dueDate,
  });

  final String name;
  final String? description;
  final String? categoryId;
  final TaskPriority priority;
  final DateTime? dueDate;
}

/// Create/edit form for a [Project]. Pass [project] to pre-fill it for
/// editing; omit it to create a new one.
class ProjectFormDialog extends StatefulWidget {
  const ProjectFormDialog({
    required this.categories,
    required this.onCreateCategory,
    this.project,
    super.key,
  });

  final Project? project;
  final List<ProjectCategory> categories;
  final Future<ProjectCategory?> Function(String name, int colorValue)
  onCreateCategory;

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  late final _nameController = TextEditingController(
    text: widget.project?.name,
  );
  late final _descriptionController = TextEditingController(
    text: widget.project?.description,
  );
  late List<ProjectCategory> _categories = widget.categories;
  late String? _categoryId = widget.project?.categoryId;
  late TaskPriority _priority = widget.project?.priority ?? TaskPriority.medium;
  late DateTime? _dueDate = widget.project?.dueDate;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_handleNameChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleNameChanged() => setState(() {});

  Future<void> _createCategory() async {
    final created = await showDialog<ProjectCategory>(
      context: context,
      builder: (context) => const CreateCategoryDialog(),
    );
    if (created == null || !mounted) return;
    final category = await widget.onCreateCategory(
      created.name,
      created.colorValue,
    );
    if (category == null || !mounted) return;
    setState(() {
      _categories = [..._categories, category];
      _categoryId = category.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.project != null;

    return AlertDialog(
      title: Text(
        isEditing
            ? l10n.projectManagementEditProjectTitle
            : l10n.projectManagementCreateProjectTitle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: l10n.projectManagementNameLabel,
              controller: _nameController,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            AppTextField(
              label: l10n.projectManagementDescriptionLabel,
              controller: _descriptionController,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            CategoryPickerField(
              categories: _categories,
              value: _categoryId,
              onChanged: (value) => setState(() => _categoryId = value),
              onCreateCategory: _createCategory,
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
          onPressed: _nameController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  ProjectFormResult(
                    name: _nameController.text.trim(),
                    description: _descriptionController.text.trim().isEmpty
                        ? null
                        : _descriptionController.text.trim(),
                    categoryId: _categoryId,
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
