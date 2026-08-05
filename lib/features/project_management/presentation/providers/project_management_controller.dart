import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_folder.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_management_view_mode.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_sort_option.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_status.dart';
import 'package:aetherdesk/features/project_management/presentation/providers/project_management_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectManagementState {
  const ProjectManagementState({
    this.projects = const [],
    this.categories = const [],
    this.folders = const [],
    this.searchQuery = '',
    this.sortOption = ProjectSortOption.dueDate,
    this.viewMode = ProjectManagementViewMode.list,
    this.filterCategoryId,
    this.filterPriority,
    this.filterFolderId,
    this.filterTag,
    this.favoritesOnly = false,
  });

  final List<Project> projects;
  final List<ProjectCategory> categories;
  final List<ProjectFolder> folders;
  final String searchQuery;
  final ProjectSortOption sortOption;
  final ProjectManagementViewMode viewMode;
  final String? filterCategoryId;
  final TaskPriority? filterPriority;
  final String? filterFolderId;
  final String? filterTag;
  final bool favoritesOnly;

  ProjectManagementState copyWith({
    List<Project>? projects,
    List<ProjectCategory>? categories,
    List<ProjectFolder>? folders,
    String? searchQuery,
    ProjectSortOption? sortOption,
    ProjectManagementViewMode? viewMode,
    String? filterCategoryId,
    bool clearFilterCategory = false,
    TaskPriority? filterPriority,
    bool clearFilterPriority = false,
    String? filterFolderId,
    bool clearFilterFolder = false,
    String? filterTag,
    bool clearFilterTag = false,
    bool? favoritesOnly,
  }) {
    return ProjectManagementState(
      projects: projects ?? this.projects,
      categories: categories ?? this.categories,
      folders: folders ?? this.folders,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      viewMode: viewMode ?? this.viewMode,
      filterCategoryId: clearFilterCategory
          ? null
          : (filterCategoryId ?? this.filterCategoryId),
      filterPriority: clearFilterPriority
          ? null
          : (filterPriority ?? this.filterPriority),
      filterFolderId: clearFilterFolder
          ? null
          : (filterFolderId ?? this.filterFolderId),
      filterTag: clearFilterTag ? null : (filterTag ?? this.filterTag),
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    );
  }
}

/// Screen state for the whole `project_management` module: the raw project,
/// category and folder collections plus the dashboard's search/sort/filter
/// selections. Derived (filtered + sorted) results are exposed separately
/// via [filteredProjectsProvider] rather than stored here, so the raw list
/// stays the single source of truth.
class ProjectManagementController extends Notifier<ProjectManagementState> {
  @override
  ProjectManagementState build() {
    final repository = ref.read(projectManagementRepositoryProvider);
    return ProjectManagementState(
      projects: repository.getProjects(),
      categories: repository.getCategories(),
      folders: repository.getFolders(),
    );
  }

  void createProject({
    required String name,
    String? description,
    String? categoryId,
    String? folderId,
    required TaskPriority priority,
    List<String> tags = const [],
    DateTime? dueDate,
  }) {
    final project = ref
        .read(createProjectUseCaseProvider)
        .call(
          name: name,
          description: description,
          categoryId: categoryId,
          folderId: folderId,
          priority: priority,
          tags: tags,
          dueDate: dueDate,
        );
    state = state.copyWith(projects: [...state.projects, project]);
  }

  void updateProjectDetails({
    required String projectId,
    required String name,
    String? description,
    String? categoryId,
    String? folderId,
    required TaskPriority priority,
    List<String> tags = const [],
    DateTime? dueDate,
  }) {
    final updated = ref
        .read(updateProjectDetailsUseCaseProvider)
        .call(
          projectId: projectId,
          name: name,
          description: description,
          categoryId: categoryId,
          folderId: folderId,
          priority: priority,
          tags: tags,
          dueDate: dueDate,
        );
    state = state.copyWith(projects: _replaceProject(updated));
  }

  void setProjectFavorite(String projectId, {required bool isFavorite}) {
    final updated = ref
        .read(setProjectFavoriteUseCaseProvider)
        .call(projectId, isFavorite: isFavorite);
    state = state.copyWith(projects: _replaceProject(updated));
  }

  void deleteProject(String projectId) {
    ref.read(deleteProjectUseCaseProvider).call(projectId);
    state = state.copyWith(
      projects: state.projects
          .where((project) => project.id != projectId)
          .toList(),
    );
  }

  void addTask({
    required String projectId,
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    final updated = ref
        .read(addTaskUseCaseProvider)
        .call(
          projectId: projectId,
          title: title,
          description: description,
          priority: priority,
          dueDate: dueDate,
        );
    state = state.copyWith(projects: _replaceProject(updated));
  }

  void updateTaskDetails({
    required String projectId,
    required String taskId,
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    final updated = ref
        .read(updateTaskDetailsUseCaseProvider)
        .call(
          projectId: projectId,
          taskId: taskId,
          title: title,
          description: description,
          priority: priority,
          dueDate: dueDate,
        );
    state = state.copyWith(projects: _replaceProject(updated));
  }

  void setTaskStatus(
    String projectId,
    String taskId, {
    required TaskStatus status,
  }) {
    final updated = ref
        .read(setTaskStatusUseCaseProvider)
        .call(projectId, taskId, status: status);
    state = state.copyWith(projects: _replaceProject(updated));
  }

  void deleteTask(String projectId, String taskId) {
    final updated = ref.read(deleteTaskUseCaseProvider).call(projectId, taskId);
    state = state.copyWith(projects: _replaceProject(updated));
  }

  void addChecklistItem({
    required String projectId,
    required String taskId,
    required String label,
  }) {
    final updated = ref
        .read(addChecklistItemUseCaseProvider)
        .call(projectId: projectId, taskId: taskId, label: label);
    state = state.copyWith(projects: _replaceProject(updated));
  }

  void setChecklistItemDone(
    String projectId,
    String taskId,
    String itemId, {
    required bool isDone,
  }) {
    final updated = ref
        .read(setChecklistItemDoneUseCaseProvider)
        .call(projectId, taskId, itemId, isDone: isDone);
    state = state.copyWith(projects: _replaceProject(updated));
  }

  void deleteChecklistItem(String projectId, String taskId, String itemId) {
    final updated = ref
        .read(deleteChecklistItemUseCaseProvider)
        .call(projectId, taskId, itemId);
    state = state.copyWith(projects: _replaceProject(updated));
  }

  void createCategory({required String name, required int colorValue}) {
    final category = ref
        .read(createCategoryUseCaseProvider)
        .call(name: name, colorValue: colorValue);
    state = state.copyWith(categories: [...state.categories, category]);
  }

  void deleteCategory(String categoryId) {
    ref.read(deleteCategoryUseCaseProvider).call(categoryId);
    state = state.copyWith(
      categories: state.categories
          .where((category) => category.id != categoryId)
          .toList(),
      projects: state.projects
          .map(
            (project) => project.categoryId == categoryId
                ? project.withoutCategory()
                : project,
          )
          .toList(),
    );
  }

  void createFolder({required String name, String? parentId}) {
    final folder = ref
        .read(createFolderUseCaseProvider)
        .call(name: name, parentId: parentId);
    state = state.copyWith(folders: [...state.folders, folder]);
  }

  void renameFolder(String folderId, {required String name}) {
    final renamed = ref
        .read(renameFolderUseCaseProvider)
        .call(folderId, name: name);
    state = state.copyWith(
      folders: state.folders
          .map((folder) => folder.id == folderId ? renamed : folder)
          .toList(),
    );
  }

  void deleteFolder(String folderId) {
    ref.read(deleteFolderUseCaseProvider).call(folderId);
    state = state.copyWith(
      folders: state.folders
          .where((folder) => folder.id != folderId)
          .map(
            (folder) => folder.parentId == folderId
                ? ProjectFolder(id: folder.id, name: folder.name)
                : folder,
          )
          .toList(),
      projects: state.projects
          .map(
            (project) => project.folderId == folderId
                ? project.withoutFolder()
                : project,
          )
          .toList(),
      filterFolderId: state.filterFolderId == folderId
          ? null
          : state.filterFolderId,
      clearFilterFolder: state.filterFolderId == folderId,
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSortOption(ProjectSortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void setViewMode(ProjectManagementViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  void setCategoryFilter(String? categoryId) {
    state = state.copyWith(
      filterCategoryId: categoryId,
      clearFilterCategory: categoryId == null,
    );
  }

  void setPriorityFilter(TaskPriority? priority) {
    state = state.copyWith(
      filterPriority: priority,
      clearFilterPriority: priority == null,
    );
  }

  void setFolderFilter(String? folderId) {
    state = state.copyWith(
      filterFolderId: folderId,
      clearFilterFolder: folderId == null,
    );
  }

  void setTagFilter(String? tag) {
    state = state.copyWith(filterTag: tag, clearFilterTag: tag == null);
  }

  void setFavoritesOnly(bool value) {
    state = state.copyWith(favoritesOnly: value);
  }

  List<Project> _replaceProject(Project updated) {
    return state.projects
        .map((project) => project.id == updated.id ? updated : project)
        .toList();
  }
}

final projectManagementControllerProvider =
    NotifierProvider<ProjectManagementController, ProjectManagementState>(
      ProjectManagementController.new,
    );

/// All folder ids nested under [rootId] (inclusive), so filtering by a
/// folder also surfaces projects filed in its subfolders.
Set<String> _folderAndDescendantIds(
  List<ProjectFolder> folders,
  String rootId,
) {
  final ids = {rootId};
  var frontier = {rootId};
  while (frontier.isNotEmpty) {
    final children = folders
        .where((folder) => frontier.contains(folder.parentId))
        .map((folder) => folder.id)
        .toSet();
    ids.addAll(children);
    frontier = children;
  }
  return ids;
}

/// Derived, read-only view of [projectManagementControllerProvider]'s
/// projects after applying the current search/sort/filter selections.
final filteredProjectsProvider = Provider<List<Project>>((ref) {
  final state = ref.watch(projectManagementControllerProvider);
  final query = state.searchQuery.trim().toLowerCase();
  final folderScope = state.filterFolderId == null
      ? null
      : _folderAndDescendantIds(state.folders, state.filterFolderId!);

  final filtered = state.projects.where((project) {
    if (state.favoritesOnly && !project.isFavorite) return false;
    if (state.filterCategoryId != null &&
        project.categoryId != state.filterCategoryId) {
      return false;
    }
    if (state.filterPriority != null &&
        project.priority != state.filterPriority) {
      return false;
    }
    if (folderScope != null && !folderScope.contains(project.folderId)) {
      return false;
    }
    if (state.filterTag != null && !project.tags.contains(state.filterTag)) {
      return false;
    }
    if (query.isEmpty) return true;
    final description = project.description?.toLowerCase() ?? '';
    return project.name.toLowerCase().contains(query) ||
        description.contains(query) ||
        project.tags.any((tag) => tag.toLowerCase().contains(query));
  }).toList();

  filtered.sort(_comparatorFor(state.sortOption));
  return filtered;
});

/// Every distinct tag across all projects, sorted alphabetically, for the
/// tag filter menu.
final allProjectTagsProvider = Provider<List<String>>((ref) {
  final projects = ref.watch(projectManagementControllerProvider).projects;
  final tags = <String>{};
  for (final project in projects) {
    tags.addAll(project.tags);
  }
  final sorted = tags.toList()..sort();
  return sorted;
});

int Function(Project, Project) _comparatorFor(ProjectSortOption option) {
  switch (option) {
    case ProjectSortOption.name:
      return (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase());
    case ProjectSortOption.dueDate:
      return (a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      };
    case ProjectSortOption.priority:
      return (a, b) => b.priority.index.compareTo(a.priority.index);
    case ProjectSortOption.createdAt:
      return (a, b) => b.createdAt.compareTo(a.createdAt);
  }
}
