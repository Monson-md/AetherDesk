/// Priority level shared by [Project] and `ProjectTask`. Intentionally has
/// no label or color here — domain entities stay Flutter-free; the
/// presentation layer maps each value to localized text and a theme color.
enum TaskPriority { low, medium, high, urgent }
