import 'package:aetherdesk/features/project_management/domain/entities/checklist_item.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_status.dart';

/// A single actionable item inside a [Project], optionally broken down into
/// a [checklist] of smaller steps.
class ProjectTask {
  const ProjectTask({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    this.dueDate,
    required this.status,
    this.checklist = const [],
  });

  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;
  final TaskStatus status;
  final List<ChecklistItem> checklist;

  bool get isDone => status == TaskStatus.done;

  int get completedChecklistCount =>
      checklist.where((item) => item.isDone).length;

  double get checklistProgress =>
      checklist.isEmpty ? 0 : completedChecklistCount / checklist.length;

  ProjectTask copyWith({TaskStatus? status, List<ChecklistItem>? checklist}) {
    return ProjectTask(
      id: id,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      status: status ?? this.status,
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
      status: status,
      checklist: checklist,
    );
  }
}
