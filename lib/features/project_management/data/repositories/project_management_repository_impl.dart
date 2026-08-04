import 'package:aetherdesk/features/project_management/domain/entities/checklist_item.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_task.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

/// In-memory implementation of [ProjectManagementRepository] — no disk I/O,
/// no backend. State lives only for the lifetime of the app process, held
/// in the private lists below rather than in the presentation layer, so a
/// future real (e.g. `Hive`-backed) implementation can replace this file
/// without any change to `domain/` or `presentation/`.
class ProjectManagementRepositoryImpl implements ProjectManagementRepository {
  final List<Project> _projects = [];
  final List<ProjectCategory> _categories = [];

  int _projectIdCounter = 0;
  int _taskIdCounter = 0;
  int _checklistItemIdCounter = 0;
  int _categoryIdCounter = 0;

  @override
  List<Project> getProjects() => List.unmodifiable(_projects);

  @override
  List<ProjectCategory> getCategories() => List.unmodifiable(_categories);

  @override
  Project createProject({
    required String name,
    String? description,
    String? categoryId,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    final project = Project(
      id: 'project-${++_projectIdCounter}',
      name: name,
      description: description,
      categoryId: categoryId,
      priority: priority,
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
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    final updated = _project(projectId).withDetails(
      name: name,
      description: description,
      categoryId: categoryId,
      priority: priority,
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
      isDone: false,
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
  Project setTaskDone(String projectId, String taskId, {required bool isDone}) {
    return _replaceTask(
      projectId,
      taskId,
      (task) => task.copyWith(isDone: isDone),
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
