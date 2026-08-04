import 'package:aetherdesk/features/project_management/domain/entities/checklist_item.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';

/// A single actionable item inside a [Project], optionally broken down into
/// a [checklist] of smaller steps.
class ProjectTask {
  const ProjectTask({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    this.dueDate,
    required this.isDone,
    this.checklist = const [],
  });

  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;
  final bool isDone;
  final List<ChecklistItem> checklist;

  int get completedChecklistCount =>
      checklist.where((item) => item.isDone).length;

  double get checklistProgress =>
      checklist.isEmpty ? 0 : completedChecklistCount / checklist.length;

  ProjectTask copyWith({bool? isDone, List<ChecklistItem>? checklist}) {
    return ProjectTask(
      id: id,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      isDone: isDone ?? this.isDone,
      checklist: checklist ?? this.checklist,
    );
  }

  /// Full replacement of the editable detail fields — see
  /// `Project.withDetails` for why this exists instead of a `copyWith` merge.
  ProjectTask withDetails({
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    return ProjectTask(
      id: id,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      isDone: isDone,
      checklist: checklist,
    );
  }
}
