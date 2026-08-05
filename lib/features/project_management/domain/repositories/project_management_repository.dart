import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_folder.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_status.dart';

/// Contract for the `project_management` module's local, in-memory store.
/// Every mutation returns the up-to-date [Project] (or void for deletions)
/// so the presentation layer's [Notifier] can replace its cached copy
/// without re-reading the whole collection.
abstract interface class ProjectManagementRepository {
  List<Project> getProjects();

  List<ProjectCategory> getCategories();

  List<ProjectFolder> getFolders();

  Project createProject({
    required String name,
    String? description,
    String? categoryId,
    String? folderId,
    required TaskPriority priority,
    List<String> tags = const [],
    DateTime? dueDate,
  });

  Project updateProjectDetails({
    required String projectId,
    required String name,
    String? description,
    String? categoryId,
    String? folderId,
    required TaskPriority priority,
    List<String> tags = const [],
    DateTime? dueDate,
  });

  Project setProjectFavorite(String projectId, {required bool isFavorite});

  void deleteProject(String projectId);

  Project addTask({
    required String projectId,
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  });

  Project updateTaskDetails({
    required String projectId,
    required String taskId,
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  });

  Project setTaskStatus(
    String projectId,
    String taskId, {
    required TaskStatus status,
  });

  Project deleteTask(String projectId, String taskId);

  Project addChecklistItem({
    required String projectId,
    required String taskId,
    required String label,
  });

  Project setChecklistItemDone(
    String projectId,
    String taskId,
    String itemId, {
    required bool isDone,
  });

  Project deleteChecklistItem(String projectId, String taskId, String itemId);

  ProjectCategory createCategory({
    required String name,
    required int colorValue,
  });

  void deleteCategory(String categoryId);

  ProjectFolder createFolder({required String name, String? parentId});

  ProjectFolder renameFolder(String folderId, {required String name});

  void deleteFolder(String folderId);
}
