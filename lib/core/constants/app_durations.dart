/// Shared animation and transition durations, so motion feels consistent
/// across every module instead of each screen picking its own timing.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration splash = Duration(seconds: 2);
}
