import 'dart:convert';

import 'package:aetherdesk/core/error/app_exception.dart';
import 'package:http/http.dart' as http;

/// Thin, reusable wrapper around authenticated `api.github.com` calls.
///
/// Deliberately knows nothing about Riverpod or [AuthController] — it takes
/// [tokenProvider] (read the current token fresh on every call, since it
/// can change) and [onUnauthorized] (what to do when GitHub says the token
/// is no longer valid) as plain callbacks, wired together in
/// `github_api_client_provider.dart`. This keeps the dependency pointing
/// one way only: the provider file knows about `core/auth`, this class does
/// not.
class GithubApiClient {
  // Public parameter names intentionally differ from the private backing
  // fields (leading underscore), so initializing formals can't be used.
  GithubApiClient({
    required Future<String?> Function() tokenProvider,
    required Future<void> Function() onUnauthorized,
    http.Client? httpClient,
  }) : _tokenProvider = tokenProvider, // ignore: prefer_initializing_formals
       _onUnauthorized = onUnauthorized, // ignore: prefer_initializing_formals
       _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'https://api.github.com';

  final Future<String?> Function() _tokenProvider;
  final Future<void> Function() _onUnauthorized;
  final http.Client _httpClient;

  /// GETs [path] (e.g. `/user`) and returns the decoded JSON body.
  ///
  /// Throws [UnauthorizedException] on a 401 (and triggers [onUnauthorized]
  /// first, so the app logs out automatically) and [ServerException] with a
  /// clear message on a 403 (GitHub's rate-limit status) or any other
  /// non-2xx response.
  Future<Map<String, dynamic>> getJson(String path) async {
    final token = await _tokenProvider();
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'Accept': 'application/vnd.github+json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      await _onUnauthorized();
      throw const UnauthorizedException(
        'Session GitHub expirée, veuillez vous reconnecter.',
      );
    }
    if (response.statusCode == 403) {
      throw const ServerException(
        'Limite de requêtes GitHub atteinte. Réessayez plus tard.',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException('Erreur GitHub (${response.statusCode}).');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
