import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const _storageKey = 'aetherdesk_project_management_store_v1';

/// Loads the last persisted `project_management` snapshot (see
/// [ProjectManagementRepositoryImpl]), if any. Called once during app
/// startup (`main.dart`) so the repository can be seeded with real data
/// before the first widget builds — the repository's own public API stays
/// synchronous throughout the app's lifetime.
Future<Map<String, dynamic>?> loadProjectManagementSeed() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_storageKey);
  if (raw == null) return null;
  return jsonDecode(raw) as Map<String, dynamic>;
}

/// Persists a `project_management` snapshot. Called fire-and-forget after
/// every mutation — see [ProjectManagementRepositoryImpl]'s doc comment.
Future<void> saveProjectManagementSnapshot(
  Map<String, dynamic> snapshot,
) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_storageKey, jsonEncode(snapshot));
}
