import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_folder.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/category_widgets.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/due_date_field.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/priority_widgets.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/tag_input_field.dart';
import 'package:flutter/material.dart';

/// Result of a submitted [ProjectFormDialog]: the raw field values, ready to
/// hand to `ProjectManagementController.createProject` or
/// `.updateProjectDetails`.
class ProjectFormResult {
  const ProjectFormResult({
    required this.name,
    required this.description,
    required this.categoryId,
    required this.folderId,
    required this.priority,
    required this.tags,
    required this.dueDate,
  });

  final String name;
  final String? description;
  final String? categoryId;
  final String? folderId;
  final TaskPriority priority;
  final List<String> tags;
  final DateTime? dueDate;
}

/// One flattened, indented entry in the folder picker dropdown.
class _FolderOption {
  const _FolderOption({required this.folder, required this.depth});

  final ProjectFolder folder;
  final int depth;
}

List<_FolderOption> _flattenFolders(
  List<ProjectFolder> folders,
  String? parentId,
  int depth,
) {
  final options = <_FolderOption>[];
  for (final folder in folders.where((f) => f.parentId == parentId)) {
    options.add(_FolderOption(folder: folder, depth: depth));
    options.addAll(_flattenFolders(folders, folder.id, depth + 1));
  }
  return options;
}

/// Create/edit form for a [Project]. Pass [project] to pre-fill it for
/// editing; omit it to create a new one.
class ProjectFormDialog extends StatefulWidget {
  const ProjectFormDialog({
    required this.categories,
    required this.folders,
    required this.onCreateCategory,
    this.project,
    super.key,
  });

  final Project? project;
  final List<ProjectCategory> categories;
  final List<ProjectFolder> folders;
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
  late String? _folderId = widget.project?.folderId;
  late TaskPriority _priority = widget.project?.priority ?? TaskPriority.medium;
  late List<String> _tags = widget.project?.tags ?? const [];
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
    final folderOptions = _flattenFolders(widget.folders, null, 0);

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
            if (folderOptions.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              DropdownButtonFormField<String?>(
                initialValue: _folderId,
                decoration: InputDecoration(
                  labelText: l10n.projectManagementFolderLabel,
                ),
                items: [
                  DropdownMenuItem(child: Text(l10n.projectManagementNoFolder)),
                  ...folderOptions.map(
                    (option) => DropdownMenuItem(
                      value: option.folder.id,
                      child: Text(
                        '${'—' * option.depth} ${option.folder.name}',
                      ),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _folderId = value),
              ),
            ],
            const SizedBox(height: AppDimensions.spacingMd),
            PrioritySelector(
              value: _priority,
              onChanged: (value) => setState(() => _priority = value),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TagInputField(
              value: _tags,
              onChanged: (value) => setState(() => _tags = value),
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
                    folderId: _folderId,
                    priority: _priority,
                    tags: _tags,
                    dueDate: _dueDate,
                  ),
                ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
