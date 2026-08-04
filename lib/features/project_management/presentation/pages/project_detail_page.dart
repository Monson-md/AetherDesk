import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/presentation/providers/project_management_controller.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/category_widgets.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/priority_widgets.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/project_form_dialog.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/task_form_dialog.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Detail screen for a single [Project]: its own fields plus the full task
/// list. Reached via a plain [Navigator] push from the dashboard rather
/// than a `GoRoute`, since it isn't a top-level module destination — see
/// `core/router/app_router.dart`'s doc comment on nested navigation.
class ProjectDetailPage extends ConsumerWidget {
  const ProjectDetailPage({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(projectManagementControllerProvider);
    final controller = ref.read(projectManagementControllerProvider.notifier);

    Project? project;
    for (final candidate in state.projects) {
      if (candidate.id == projectId) {
        project = candidate;
        break;
      }
    }

    if (project == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return const Scaffold(body: AppLoadingIndicator());
    }

    final currentProject = project;
    ProjectCategory? category;
    for (final candidate in state.categories) {
      if (candidate.id == currentProject.categoryId) {
        category = candidate;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentProject.name),
        actions: [
          IconButton(
            icon: Icon(
              currentProject.isFavorite ? Icons.star : Icons.star_border,
              color: currentProject.isFavorite ? Colors.amber : null,
            ),
            tooltip: currentProject.isFavorite
                ? l10n.projectManagementUnfavoriteTooltip
                : l10n.projectManagementFavoriteTooltip,
            onPressed: () => controller.setProjectFavorite(
              currentProject.id,
              isFavorite: !currentProject.isFavorite,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _editProject(context, ref, currentProject),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _deleteProject(context, ref, currentProject),
          ),
        ],
      ),
      body: ResponsiveContentWrapper(
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          children: [
            if (currentProject.description != null &&
                currentProject.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                child: Text(
                  currentProject.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            Wrap(
              spacing: AppDimensions.spacingSm,
              runSpacing: AppDimensions.spacingSm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                PriorityBadge(priority: currentProject.priority),
                if (category != null) CategoryChip(category: category),
                if (currentProject.dueDate != null)
                  Chip(
                    avatar: const Icon(Icons.event_outlined, size: 16),
                    label: Text(
                      DateFormat.yMMMd().format(currentProject.dueDate!),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.projectManagementTasksTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(l10n.projectManagementNewTask),
                  onPressed: () => _addTask(context, ref, currentProject.id),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            if (currentProject.tasks.isEmpty)
              EmptyStateWidget(
                icon: Icons.checklist_outlined,
                title: l10n.projectManagementNoTasksYet,
                message: l10n.projectManagementNoTasksYet,
              )
            else
              for (final task in currentProject.tasks)
                TaskTile(
                  task: task,
                  onToggleDone: (isDone) => controller.setTaskDone(
                    currentProject.id,
                    task.id,
                    isDone: isDone,
                  ),
                  onEdit: () =>
                      _editTask(context, ref, currentProject.id, task.id),
                  onDelete: () =>
                      controller.deleteTask(currentProject.id, task.id),
                  onAddChecklistItem: (label) => controller.addChecklistItem(
                    projectId: currentProject.id,
                    taskId: task.id,
                    label: label,
                  ),
                  onToggleChecklistItem: (item, isDone) =>
                      controller.setChecklistItemDone(
                        currentProject.id,
                        task.id,
                        item.id,
                        isDone: isDone,
                      ),
                  onDeleteChecklistItem: (item) => controller
                      .deleteChecklistItem(currentProject.id, task.id, item.id),
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _editProject(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) async {
    final controller = ref.read(projectManagementControllerProvider.notifier);
    final result = await showDialog<ProjectFormResult>(
      context: context,
      builder: (context) => ProjectFormDialog(
        project: project,
        categories: ref.read(projectManagementControllerProvider).categories,
        onCreateCategory: (name, colorValue) async {
          controller.createCategory(name: name, colorValue: colorValue);
          final categories = ref
              .read(projectManagementControllerProvider)
              .categories;
          return categories.isEmpty ? null : categories.last;
        },
      ),
    );
    if (result == null) return;
    controller.updateProjectDetails(
      projectId: project.id,
      name: result.name,
      description: result.description,
      categoryId: result.categoryId,
      priority: result.priority,
      dueDate: result.dueDate,
    );
  }

  Future<void> _deleteProject(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppAlertDialog.show(
      context,
      title: l10n.projectManagementDeleteProjectTitle,
      message: l10n.projectManagementDeleteProjectMessage,
      confirmLabel: l10n.commonConfirm,
      cancelLabel: l10n.commonCancel,
    );
    if (!confirmed) return;
    ref
        .read(projectManagementControllerProvider.notifier)
        .deleteProject(project.id);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _addTask(
    BuildContext context,
    WidgetRef ref,
    String projectId,
  ) async {
    final result = await showDialog<TaskFormResult>(
      context: context,
      builder: (context) => const TaskFormDialog(),
    );
    if (result == null) return;
    ref
        .read(projectManagementControllerProvider.notifier)
        .addTask(
          projectId: projectId,
          title: result.title,
          description: result.description,
          priority: result.priority,
          dueDate: result.dueDate,
        );
  }

  Future<void> _editTask(
    BuildContext context,
    WidgetRef ref,
    String projectId,
    String taskId,
  ) async {
    final project = ref
        .read(projectManagementControllerProvider)
        .projects
        .firstWhere((p) => p.id == projectId);
    final task = project.tasks.firstWhere((t) => t.id == taskId);
    final result = await showDialog<TaskFormResult>(
      context: context,
      builder: (context) => TaskFormDialog(task: task),
    );
    if (result == null) return;
    ref
        .read(projectManagementControllerProvider.notifier)
        .updateTaskDetails(
          projectId: projectId,
          taskId: taskId,
          title: result.title,
          description: result.description,
          priority: result.priority,
          dueDate: result.dueDate,
        );
  }
}
