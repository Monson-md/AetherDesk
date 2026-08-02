/// Small `DateTime` helpers reused across modules (project timestamps,
/// vault entry metadata, etc.).
extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String toIso8601DateOnly() => toIso8601String().split('T').first;
}
