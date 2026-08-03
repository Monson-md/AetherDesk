import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One request/response pair from the device flow, kept for on-device
/// diagnosis — there's no PC/adb logcat available to read `debugPrint`
/// output on the phone this runs on.
class GithubAuthLogEntry {
  const GithubAuthLogEntry({
    required this.timestamp,
    required this.label,
    required this.statusCode,
    required this.body,
  });

  final DateTime timestamp;
  final String label;
  final int statusCode;

  /// Already redacted via [redactGithubToken] before being stored.
  final String body;
}

/// Replaces any `access_token` value with `***` so log entries are always
/// safe to display or copy to the clipboard.
String redactGithubToken(String body) {
  return body.replaceAll(
    RegExp(r'"access_token"\s*:\s*"[^"]*"'),
    '"access_token":"***"',
  );
}

const _maxLogEntries = 20;

class GithubAuthLogNotifier extends Notifier<List<GithubAuthLogEntry>> {
  @override
  List<GithubAuthLogEntry> build() => [];

  void add(GithubAuthLogEntry entry) {
    final updated = [...state, entry];
    state = updated.length > _maxLogEntries
        ? updated.sublist(updated.length - _maxLogEntries)
        : updated;
  }
}

final githubAuthLogProvider =
    NotifierProvider<GithubAuthLogNotifier, List<GithubAuthLogEntry>>(
      GithubAuthLogNotifier.new,
    );
