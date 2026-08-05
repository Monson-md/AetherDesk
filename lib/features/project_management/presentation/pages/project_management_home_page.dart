import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_management_view_mode.dart';
import 'package:aetherdesk/features/project_management/presentation/pages/project_detail_page.dart';
import 'package:aetherdesk/features/project_management/presentation/providers/project_management_controller.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/folder_form_dialog.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/folder_tree_view.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/kanban_board_view.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/manage_categories_dialog.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/project_calendar_view.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/project_card.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/project_filter_bar.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/project_form_dialog.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/project_search_field.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/project_sort_menu.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/view_mode_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `project_management` module: a folder-tree drawer,
/// a search/sort/filter toolbar with a list/Kanban/calendar view switch,
/// and entry points to create a project or manage categories.
class ProjectManagementHomePage extends ConsumerWidget {
  const ProjectManagementHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.projectManagement);
    final state = ref.watch(projectManagementControllerProvider);
    final controller = ref.read(projectManagementControllerProvider.notifier);
    final filteredProjects = ref.watch(filteredProjectsProvider);
    final allTags = ref.watch(allProjectTagsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(destination.label),
        actions: [
          IconButton(
            icon: const Icon(Icons.label_outline),
            tooltip: l10n.projectManagementCategoryLabel,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => const ManageCategoriesDialog(),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: FolderTreeView(
          folders: state.folders,
          selectedFolderId: state.filterFolderId,
          onSelectFolder: controller.setFolderFilter,
          onCreateFolder: (parentId) => _createFolder(context, ref, parentId),
          onRenameFolder: (folder) =>
              controller.renameFolder(folder.id, name: folder.name),
          onDeleteFolder: (folder) => controller.deleteFolder(folder.id),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createProject(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.projectManagementNewProject),
      ),
      body: ResponsiveContentWrapper(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ProjectSearchField(
                      initialValue: state.searchQuery,
                      onChanged: controller.setSearchQuery,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  ProjectSortMenu(
                    value: state.sortOption,
                    onChanged: controller.setSortOption,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  ViewModeToggle(
                    value: state.viewMode,
                    onChanged: controller.setViewMode,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              ProjectFilterBar(
                categories: state.categories,
                selectedCategoryId: state.filterCategoryId,
                onCategoryChanged: controller.setCategoryFilter,
                selectedPriority: state.filterPriority,
                onPriorityChanged: controller.setPriorityFilter,
                tags: allTags,
                selectedTag: state.filterTag,
                onTagChanged: controller.setTagFilter,
                favoritesOnly: state.favoritesOnly,
                onFavoritesOnlyChanged: controller.setFavoritesOnly,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Expanded(
                child: state.projects.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.folder_open_outlined,
                        title: l10n.projectManagementEmptyTitle,
                        message: l10n.projectManagementEmptyMessage,
                      )
                    : filteredProjects.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.search_off,
                        title: l10n.projectManagementNoResultsTitle,
                        message: l10n.projectManagementNoResultsMessage,
                      )
                    : _buildView(context, ref, state, filteredProjects),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildView(
    BuildContext context,
    WidgetRef ref,
    ProjectManagementState state,
    List<Project> filteredProjects,
  ) {
    final controller = ref.read(projectManagementControllerProvider.notifier);
    switch (state.viewMode) {
      case ProjectManagementViewMode.list:
        return _ProjectGrid(
          projects: filteredProjects,
          categories: state.categories,
          onOpen: (project) => _openProject(context, project.id),
          onFavoriteToggle: (project) => controller.setProjectFavorite(
            project.id,
            isFavorite: !project.isFavorite,
          ),
        );
      case ProjectManagementViewMode.kanban:
        return KanbanBoardView(
          projects: filteredProjects,
          onStatusChanged: (projectId, taskId, status) =>
              controller.setTaskStatus(projectId, taskId, status: status),
        );
      case ProjectManagementViewMode.calendar:
        return ProjectCalendarView(
          projects: filteredProjects,
          onOpenProject: (project) => _openProject(context, project.id),
        );
    }
  }

  void _openProject(BuildContext context, String projectId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProjectDetailPage(projectId: projectId),
      ),
    );
  }

  Future<void> _createFolder(
    BuildContext context,
    WidgetRef ref,
    String? parentId,
  ) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const FolderFormDialog(),
    );
    if (name == null) return;
    ref
        .read(projectManagementControllerProvider.notifier)
        .createFolder(name: name, parentId: parentId);
  }

  Future<void> _createProject(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(projectManagementControllerProvider.notifier);
    final result = await showDialog<ProjectFormResult>(
      context: context,
      builder: (context) => ProjectFormDialog(
        categories: ref.read(projectManagementControllerProvider).categories,
        folders: ref.read(projectManagementControllerProvider).folders,
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
    controller.createProject(
      name: result.name,
      description: result.description,
      categoryId: result.categoryId,
      folderId: result.folderId,
      priority: result.priority,
      tags: result.tags,
      dueDate: result.dueDate,
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({
    required this.projects,
    required this.categories,
    required this.onOpen,
    required this.onFavoriteToggle,
  });

  final List<Project> projects;
  final List<ProjectCategory> categories;
  final ValueChanged<Project> onOpen;
  final ValueChanged<Project> onFavoriteToggle;

  ProjectCategory? _categoryFor(String? categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 340).floor().clamp(1, 4);
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppDimensions.spacingMd,
            crossAxisSpacing: AppDimensions.spacingMd,
            childAspectRatio: 1.4,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return ProjectCard(
              project: project,
              category: _categoryFor(project.categoryId),
              onTap: () => onOpen(project),
              onFavoriteToggle: () => onFavoriteToggle(project),
            );
          },
        );
      },
    );
  }
}
