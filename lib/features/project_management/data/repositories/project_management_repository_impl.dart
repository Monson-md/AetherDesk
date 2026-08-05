import 'dart:async';

import 'package:aetherdesk/features/project_management/data/repositories/project_management_local_store.dart';
import 'package:aetherdesk/features/project_management/domain/entities/checklist_item.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_folder.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_task.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_status.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

/// Real, disk-backed implementation of [ProjectManagementRepository].
///
/// The public API stays synchronous — like the in-memory version this
/// replaces — because [seed] (loaded from `shared_preferences` in
/// `main.dart`, before the app's first frame) already hydrates every list
/// at construction time. Every mutation updates the in-memory lists
/// synchronously (so callers see the change immediately) and also fires
/// off a background write via [saveProjectManagementSnapshot] to persist
/// it for the next launch; that write isn't awaited by callers, trading a
/// small window of risk (a crash right after a mutation could lose that
/// one write) for keeping every usecase/controller call site unchanged.
class ProjectManagementRepositoryImpl implements ProjectManagementRepository {
  ProjectManagementRepositoryImpl({Map<String, dynamic>? seed}) {
    if (seed != null) _hydrate(seed);
  }

  List<Project> _projects = [];
  List<ProjectCategory> _categories = [];
  List<ProjectFolder> _folders = [];

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
    _persist();
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
    final result = _replaceProject(updated);
    _persist();
    return result;
  }

  @override
  Project setProjectFavorite(String projectId, {required bool isFavorite}) {
    final updated = _project(projectId).copyWith(isFavorite: isFavorite);
    final result = _replaceProject(updated);
    _persist();
    return result;
  }

  @override
  void deleteProject(String projectId) {
    _projects.removeWhere((project) => project.id == projectId);
    _persist();
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
    final result = _replaceProject(
      project.copyWith(tasks: [...project.tasks, task]),
    );
    _persist();
    return result;
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
    final result = _replaceTask(
      projectId,
      taskId,
      (task) => task.withDetails(
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
      ),
    );
    _persist();
    return result;
  }

  @override
  Project setTaskStatus(
    String projectId,
    String taskId, {
    required TaskStatus status,
  }) {
    final result = _replaceTask(
      projectId,
      taskId,
      (task) => task.copyWith(status: status),
    );
    _persist();
    return result;
  }

  @override
  Project deleteTask(String projectId, String taskId) {
    final project = _project(projectId);
    final tasks = project.tasks.where((task) => task.id != taskId).toList();
    final result = _replaceProject(project.copyWith(tasks: tasks));
    _persist();
    return result;
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
    final result = _replaceTask(
      projectId,
      taskId,
      (task) => task.copyWith(checklist: [...task.checklist, item]),
    );
    _persist();
    return result;
  }

  @override
  Project setChecklistItemDone(
    String projectId,
    String taskId,
    String itemId, {
    required bool isDone,
  }) {
    final result = _replaceTask(
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
    _persist();
    return result;
  }

  @override
  Project deleteChecklistItem(String projectId, String taskId, String itemId) {
    final result = _replaceTask(
      projectId,
      taskId,
      (task) => task.copyWith(
        checklist: task.checklist.where((item) => item.id != itemId).toList(),
      ),
    );
    _persist();
    return result;
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
    _persist();
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
    _persist();
  }

  @override
  ProjectFolder createFolder({required String name, String? parentId}) {
    final folder = ProjectFolder(
      id: 'folder-${++_folderIdCounter}',
      name: name,
      parentId: parentId,
    );
    _folders.add(folder);
    _persist();
    return folder;
  }

  @override
  ProjectFolder renameFolder(String folderId, {required String name}) {
    final index = _folders.indexWhere((folder) => folder.id == folderId);
    final renamed = _folders[index].withName(name);
    _folders[index] = renamed;
    _persist();
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
    _persist();
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

  void _persist() {
    unawaited(saveProjectManagementSnapshot(_toJson()));
  }

  void _hydrate(Map<String, dynamic> seed) {
    _projects = (seed['projects'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_projectFromJson)
        .toList();
    _categories = (seed['categories'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_categoryFromJson)
        .toList();
    _folders = (seed['folders'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_folderFromJson)
        .toList();
    _projectIdCounter = seed['projectIdCounter'] as int;
    _taskIdCounter = seed['taskIdCounter'] as int;
    _checklistItemIdCounter = seed['checklistItemIdCounter'] as int;
    _categoryIdCounter = seed['categoryIdCounter'] as int;
    _folderIdCounter = seed['folderIdCounter'] as int;
  }

  Map<String, dynamic> _toJson() => {
    'projects': _projects.map(_projectToJson).toList(),
    'categories': _categories.map(_categoryToJson).toList(),
    'folders': _folders.map(_folderToJson).toList(),
    'projectIdCounter': _projectIdCounter,
    'taskIdCounter': _taskIdCounter,
    'checklistItemIdCounter': _checklistItemIdCounter,
    'categoryIdCounter': _categoryIdCounter,
    'folderIdCounter': _folderIdCounter,
  };

  Map<String, dynamic> _projectToJson(Project project) => {
    'id': project.id,
    'name': project.name,
    'description': project.description,
    'categoryId': project.categoryId,
    'folderId': project.folderId,
    'priority': project.priority.name,
    'tags': project.tags,
    'dueDate': project.dueDate?.toIso8601String(),
    'createdAt': project.createdAt.toIso8601String(),
    'isFavorite': project.isFavorite,
    'tasks': project.tasks.map(_taskToJson).toList(),
  };

  Project _projectFromJson(Map<String, dynamic> json) => Project(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    categoryId: json['categoryId'] as String?,
    folderId: json['folderId'] as String?,
    priority: TaskPriority.values.byName(json['priority'] as String),
    tags: (json['tags'] as List<dynamic>).cast<String>(),
    dueDate: (json['dueDate'] as String?) == null
        ? null
        : DateTime.parse(json['dueDate'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    isFavorite: json['isFavorite'] as bool,
    tasks: (json['tasks'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_taskFromJson)
        .toList(),
  );

  Map<String, dynamic> _taskToJson(ProjectTask task) => {
    'id': task.id,
    'title': task.title,
    'description': task.description,
    'priority': task.priority.name,
    'dueDate': task.dueDate?.toIso8601String(),
    'status': task.status.name,
    'checklist': task.checklist.map(_checklistItemToJson).toList(),
  };

  ProjectTask _taskFromJson(Map<String, dynamic> json) => ProjectTask(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    priority: TaskPriority.values.byName(json['priority'] as String),
    dueDate: (json['dueDate'] as String?) == null
        ? null
        : DateTime.parse(json['dueDate'] as String),
    status: TaskStatus.values.byName(json['status'] as String),
    checklist: (json['checklist'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_checklistItemFromJson)
        .toList(),
  );

  Map<String, dynamic> _checklistItemToJson(ChecklistItem item) => {
    'id': item.id,
    'label': item.label,
    'isDone': item.isDone,
  };

  ChecklistItem _checklistItemFromJson(Map<String, dynamic> json) =>
      ChecklistItem(
        id: json['id'] as String,
        label: json['label'] as String,
        isDone: json['isDone'] as bool,
      );

  Map<String, dynamic> _categoryToJson(ProjectCategory category) => {
    'id': category.id,
    'name': category.name,
    'colorValue': category.colorValue,
  };

  ProjectCategory _categoryFromJson(Map<String, dynamic> json) =>
      ProjectCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        colorValue: json['colorValue'] as int,
      );

  Map<String, dynamic> _folderToJson(ProjectFolder folder) => {
    'id': folder.id,
    'name': folder.name,
    'parentId': folder.parentId,
  };

  ProjectFolder _folderFromJson(Map<String, dynamic> json) => ProjectFolder(
    id: json['id'] as String,
    name: json['name'] as String,
    parentId: json['parentId'] as String?,
  );
}
