import 'dart:convert';

import 'package:aetherdesk/core/constants/app_version.dart';
import 'package:aetherdesk/core/services/updates/app_update_info.dart';
import 'package:aetherdesk/core/services/updates/app_update_service.dart';
import 'package:http/http.dart' as http;

/// Real [AppUpdateService] backed by the public, unauthenticated GitHub
/// Releases API — no account, token or paid plan needed.
class GithubAppUpdateService implements AppUpdateService {
  GithubAppUpdateService({
    this.repoOwner = 'Monson-md',
    this.repoName = 'AetherDesk',
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String repoOwner;
  final String repoName;
  final http.Client _client;

  @override
  Future<AppUpdateInfo?> checkForUpdate() async {
    final uri = Uri.https(
      'api.github.com',
      '/repos/$repoOwner/$repoName/releases/latest',
    );
    try {
      final response = await _client
          .get(uri, headers: const {'Accept': 'application/vnd.github+json'})
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = json['tag_name'] as String?;
      final htmlUrl = json['html_url'] as String?;
      final body = json['body'] as String?;
      if (tagName == null || htmlUrl == null) return null;

      final latestVersion = tagName.startsWith('v')
          ? tagName.substring(1)
          : tagName;
      return AppUpdateInfo(
        latestVersion: latestVersion,
        currentVersion: appVersion,
        isUpdateAvailable: _isNewer(latestVersion, appVersion),
        releaseUrl: htmlUrl,
        releaseNotes: body ?? '',
      );
    } on Exception {
      return null;
    }
  }

  /// Compares two `x.y.z`-style version strings. Missing/non-numeric
  /// segments are treated as `0`, so `1.2` compares equal to `1.2.0`.
  bool _isNewer(String candidate, String current) {
    final candidateParts = _versionParts(candidate);
    final currentParts = _versionParts(current);
    for (var i = 0; i < 3; i++) {
      if (candidateParts[i] != currentParts[i]) {
        return candidateParts[i] > currentParts[i];
      }
    }
    return false;
  }

  List<int> _versionParts(String version) {
    final segments = version.split('.');
    return List.generate(3, (index) {
      if (index >= segments.length) return 0;
      return int.tryParse(segments[index]) ?? 0;
    });
  }
}
