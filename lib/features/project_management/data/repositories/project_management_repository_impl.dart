import 'package:aetherdesk/features/project_management/domain/entities/checklist_item.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_folder.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_task.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_status.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

/// In-memory implementation of [ProjectManagementRepository] — no disk I/O,
/// no backend. State lives only for the lifetime of the app process, held
/// in the private lists below rather than in the presentation layer, so a
/// future real (e.g. `Hive`-backed) implementation can replace this file
/// without any change to `domain/` or `presentation/`.
class ProjectManagementRepositoryImpl implements ProjectManagementRepository {
  final List<Project> _projects = [];
  final List<ProjectCategory> _categories = [];
  final List<ProjectFolder> _folders = [];

  int _projectIdCounter = 0;
  int _taskIdCounter = 0;
  int _checklistItemIdCounter = 0;
  int _categoryIdCounter = 0;
  int _folderIdCounter = 0;

  @override
  List<Project> getProjects() => List.unmodifiable(_projects);

  @override
  List<ProjectCategory> getCategories() => List.unmodifiable(_categories);

  @override
  List<ProjectFolder> getFolders() => List.unmodifiable(_folders);

  @override
  Project createProject({
    required String name,
    String? description,
    String? categoryId,
    String? folderId,
    required TaskPriority priority,
    List<String> tags = const [],
    DateTime? dueDate,
  }) {
    final project = Project(
      id: 'project-${++_projectIdCounter}',
      name: name,
      description: description,
      categoryId: categoryId,
      folderId: folderId,
      priority: priority,
      tags: tags,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      isFavorite: false,
    );
    _projects.add(project);
    return project;
  }

  @override
  Project updateProjectDetails({
    required String projectId,
    required String name,
    String? description,
    String? categoryId,
    String? folderId,
    required TaskPriority priority,
    List<String> tags = const [],
    DateTime? dueDate,
  }) {
    final updated = _project(projectId).withDetails(
      name: name,
      description: description,
      categoryId: categoryId,
      folderId: folderId,
      priority: priority,
      tags: tags,
      dueDate: dueDate,
    );
    return _replaceProject(updated);
  }

  @override
  Project setProjectFavorite(String projectId, {required bool isFavorite}) {
    final updated = _project(projectId).copyWith(isFavorite: isFavorite);
    return _replaceProject(updated);
  }

  @override
  void deleteProject(String projectId) {
    _projects.removeWhere((project) => project.id == projectId);
  }

  @override
  Project addTask({
    required String projectId,
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    final project = _project(projectId);
    final task = ProjectTask(
      id: 'task-${++_taskIdCounter}',
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      status: TaskStatus.todo,
    );
    return _replaceProject(project.copyWith(tasks: [...project.tasks, task]));
  }

  @override
  Project updateTaskDetails({
    required String projectId,
    required String taskId,
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    return _replaceTask(
      projectId,
      taskId,
      (task) => task.withDetails(
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
      ),
    );
  }

  @override
  Project setTaskStatus(
    String projectId,
    String taskId, {
    required TaskStatus status,
  }) {
    return _replaceTask(
      projectId,
      taskId,
      (task) => task.copyWith(status: status),
    );
  }

  @override
  Project deleteTask(String projectId, String taskId) {
    final project = _project(projectId);
    final tasks = project.tasks.where((task) => task.id != taskId).toList();
    return _replaceProject(project.copyWith(tasks: tasks));
  }

  @override
  Project addChecklistItem({
    required String projectId,
    required String taskId,
    required String label,
  }) {
    final item = ChecklistItem(
      id: 'checklist-${++_checklistItemIdCounter}',
      label: label,
      isDone: false,
    );
    return _replaceTask(
      projectId,
      taskId,
      (task) => task.copyWith(checklist: [...task.checklist, item]),
    );
  }

  @override
  Project setChecklistItemDone(
    String projectId,
    String taskId,
    String itemId, {
    required bool isDone,
  }) {
    return _replaceTask(
      projectId,
      taskId,
      (task) => task.copyWith(
        checklist: task.checklist
            .map(
              (item) =>
                  item.id == itemId ? item.copyWith(isDone: isDone) : item,
            )
            .toList(),
      ),
    );
  }

  @override
  Project deleteChecklistItem(String projectId, String taskId, String itemId) {
    return _replaceTask(
      projectId,
      taskId,
      (task) => task.copyWith(
        checklist: task.checklist.where((item) => item.id != itemId).toList(),
      ),
    );
  }

  @override
  ProjectCategory createCategory({
    required String name,
    required int colorValue,
  }) {
    final category = ProjectCategory(
      id: 'category-${++_categoryIdCounter}',
      name: name,
      colorValue: colorValue,
    );
    _categories.add(category);
    return category;
  }

  @override
  void deleteCategory(String categoryId) {
    _categories.removeWhere((category) => category.id == categoryId);
    for (var i = 0; i < _projects.length; i++) {
      if (_projects[i].categoryId == categoryId) {
        _projects[i] = _projects[i].withoutCategory();
      }
    }
  }

  @override
  ProjectFolder createFolder({required String name, String? parentId}) {
    final folder = ProjectFolder(
      id: 'folder-${++_folderIdCounter}',
      name: name,
      parentId: parentId,
    );
    _folders.add(folder);
    return folder;
  }

  @override
  ProjectFolder renameFolder(String folderId, {required String name}) {
    final index = _folders.indexWhere((folder) => folder.id == folderId);
    final renamed = _folders[index].withName(name);
    _folders[index] = renamed;
    return renamed;
  }

  @override
  void deleteFolder(String folderId) {
    _folders.removeWhere((folder) => folder.id == folderId);
    for (var i = 0; i < _folders.length; i++) {
      if (_folders[i].parentId == folderId) {
        _folders[i] = ProjectFolder(id: _folders[i].id, name: _folders[i].name);
      }
    }
    for (var i = 0; i < _projects.length; i++) {
      if (_projects[i].folderId == folderId) {
        _projects[i] = _projects[i].withoutFolder();
      }
    }
  }

  Project _project(String projectId) =>
      _projects.firstWhere((project) => project.id == projectId);

  Project _replaceProject(Project updated) {
    final index = _projects.indexWhere((project) => project.id == updated.id);
    _projects[index] = updated;
    return updated;
  }

  Project _replaceTask(
    String projectId,
    String taskId,
    ProjectTask Function(ProjectTask task) transform,
  ) {
    final project = _project(projectId);
    final tasks = project.tasks
        .map((task) => task.id == taskId ? transform(task) : task)
        .toList();
    return _replaceProject(project.copyWith(tasks: tasks));
  }
}
