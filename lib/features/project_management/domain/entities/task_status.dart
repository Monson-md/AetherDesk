/// Workflow state of a [ProjectTask], driving both the checkbox in the task
/// list and the three-column board in `KanbanBoardView`. Intentionally has
/// no label or color here — domain entities stay Flutter-free; the
/// presentation layer maps each value to localized text and a theme color.
enum TaskStatus { todo, inProgress, done }
