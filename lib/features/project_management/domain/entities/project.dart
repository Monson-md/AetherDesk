import 'package:aetherdesk/features/project_management/domain/entities/project_task.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';

/// The root entity of the `project_management` module: a named body of work
/// with an optional [categoryId], a [priority], an optional [dueDate] and a
/// list of [tasks].
class Project {
  const Project({
    required this.id,
    required this.name,
    this.description,
    this.categoryId,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    required this.isFavorite,
    this.tasks = const [],
  });

  final String id;
  final String name;
  final String? description;
  final String? categoryId;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final bool isFavorite;
  final List<ProjectTask> tasks;

  int get completedTaskCount => tasks.where((task) => task.isDone).length;

  double get taskProgress =>
      tasks.isEmpty ? 0 : completedTaskCount / tasks.length;

  Project copyWith({bool? isFavorite, List<ProjectTask>? tasks}) {
    return Project(
      id: id,
      name: name,
      description: description,
      categoryId: categoryId,
      priority: priority,
      dueDate: dueDate,
      createdAt: createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      tasks: tasks ?? this.tasks,
    );
  }

  /// Full replacement of the editable detail fields — used for the edit
  /// form, where every field (including nullable ones like [description]
  /// or [dueDate]) is supplied explicitly, so there's no ambiguity between
  /// "not changed" and "cleared" the way a `copyWith` merge would have.
  Project withDetails({
    required String name,
    String? description,
    String? categoryId,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    return Project(
      id: id,
      name: name,
      description: description,
      categoryId: categoryId,
      priority: priority,
      dueDate: dueDate,
      createdAt: createdAt,
      isFavorite: isFavorite,
      tasks: tasks,
    );
  }

  Project withoutCategory() {
    return Project(
      id: id,
      name: name,
      description: description,
      priority: priority,
      dueDate: dueDate,
      createdAt: createdAt,
      isFavorite: isFavorite,
      tasks: tasks,
    );
  }
}
