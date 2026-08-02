import 'dart:convert';

import 'package:aetherdesk/core/services/github/github_device_code.dart';
import 'package:http/http.dart' as http;

/// Key used to persist the GitHub access token via [SecureStorageService].
/// Defined here (next to the code that produces the token) so every
/// consumer imports it from one place instead of repeating the string.
const String githubTokenStorageKey = 'github_access_token';

/// The registered OAuth App's client ID. Device flow apps have no client
/// secret — the flow's security comes from the short-lived user code being
/// entered on github.com itself, not from a secret embedded in the APK.
const String githubOAuthClientId = 'Ov23libQB3Mor4GRNeow';

/// Errors specific to the device authorization flow, mirroring the
/// `error` values GitHub's polling endpoint can return.
sealed class GithubAuthException implements Exception {
  const GithubAuthException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class GithubAuthExpiredException extends GithubAuthException {
  const GithubAuthExpiredException([
    super.message = 'Le code a expiré, veuillez recommencer.',
  ]);
}

final class GithubAuthDeniedException extends GithubAuthException {
  const GithubAuthDeniedException([super.message = 'Connexion refusée.']);
}

final class GithubAuthUnknownException extends GithubAuthException {
  const GithubAuthUnknownException([
    super.message = 'Erreur inattendue lors de la connexion.',
  ]);
}

/// Contract for GitHub's OAuth Device Authorization Flow
/// (https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#device-flow).
/// Defined as an interface — even though only one real implementation makes
/// sense here — so `core/auth` depends on an abstraction, consistent with
/// every other service in `core/services/`.
abstract interface class GithubAuthService {
  /// Step 1: requests a fresh [GithubDeviceCode] to start the flow.
  Future<GithubDeviceCode> requestDeviceCode();

  /// Step 2: polls until the user has authorized [deviceCode], respecting
  /// its `interval` (and GitHub's `slow_down` responses), then returns the
  /// access token. Throws a [GithubAuthException] on expiry/denial.
  Future<String> pollForAccessToken(GithubDeviceCode deviceCode);
}

class GithubAuthServiceImpl implements GithubAuthService {
  GithubAuthServiceImpl({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _deviceCodeUrl = 'https://github.com/login/device/code';
  static const _accessTokenUrl = 'https://github.com/login/oauth/access_token';
  static const _headers = {'Accept': 'application/json'};

  final http.Client _httpClient;

  @override
  Future<GithubDeviceCode> requestDeviceCode() async {
    final response = await _httpClient.post(
      Uri.parse(_deviceCodeUrl),
      headers: _headers,
      body: {'client_id': githubOAuthClientId, 'scope': 'repo workflow'},
    );

    if (response.statusCode != 200) {
      throw const GithubAuthUnknownException();
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return GithubDeviceCode(
      deviceCode: json['device_code'] as String,
      userCode: json['user_code'] as String,
      verificationUri: json['verification_uri'] as String,
      expiresIn: json['expires_in'] as int,
      interval: json['interval'] as int,
    );
  }

  @override
  Future<String> pollForAccessToken(GithubDeviceCode deviceCode) async {
    var interval = deviceCode.interval;
    final deadline = DateTime.now().add(
      Duration(seconds: deviceCode.expiresIn),
    );

    while (DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(Duration(seconds: interval));

      final response = await _httpClient.post(
        Uri.parse(_accessTokenUrl),
        headers: _headers,
        body: {
          'client_id': githubOAuthClientId,
          'device_code': deviceCode.deviceCode,
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
        },
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final error = json['error'] as String?;

      if (error == null) {
        return json['access_token'] as String;
      }

      if (error == 'authorization_pending') {
        continue;
      } else if (error == 'slow_down') {
        // GitHub's OAuth spec: bump by 5s if it doesn't say the new value.
        interval = (json['interval'] as int?) ?? (interval + 5);
      } else if (error == 'expired_token') {
        throw const GithubAuthExpiredException();
      } else if (error == 'access_denied') {
        throw const GithubAuthDeniedException();
      } else {
        throw const GithubAuthUnknownException();
      }
    }

    throw const GithubAuthExpiredException();
  }
}
