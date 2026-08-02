/// Small string helpers reused across modules.
extension StringExtensions on String {
  bool get isBlank => trim().isEmpty;

  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
