/// A single checkable line inside a `ProjectTask`'s checklist.
class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.label,
    required this.isDone,
  });

  final String id;
  final String label;
  final bool isDone;

  ChecklistItem copyWith({bool? isDone}) {
    return ChecklistItem(id: id, label: label, isDone: isDone ?? this.isDone);
  }
}
