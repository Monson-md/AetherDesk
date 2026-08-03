import 'dart:convert';

import 'package:aetherdesk/core/services/github/github_device_code.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Key used to persist the GitHub access token via [SecureStorageService].
/// Defined here (next to the code that produces the token) so every
/// consumer imports it from one place instead of repeating the string.
const String githubTokenStorageKey = 'github_access_token';

/// The registered OAuth App's client ID. Device flow apps have no client
/// secret — the flow's security comes from the short-lived user code being
/// entered on github.com itself, not from a secret embedded in the APK.
const String githubOAuthClientId = 'Ov23libQB3Mor4GRNeow';

/// GitHub rejects any request with no `User-Agent` header (both
/// github.com/login/... and api.github.com), independently of
/// `Accept`/auth — see
/// https://docs.github.com/en/rest/using-the-rest-api/getting-started-with-the-rest-api#user-agent-required.
const String githubUserAgent = 'AetherDesk';

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

/// Any other fatal response from GitHub: a non-200 HTTP status, a body
/// that isn't valid JSON, `incorrect_device_code`, or any `error` value
/// not otherwise handled. Carries the raw HTTP status and error/message
/// field so it's diagnosable instead of hidden behind a generic message.
final class GithubAuthRequestException extends GithubAuthException {
  GithubAuthRequestException({required this.statusCode, this.errorCode})
    : super(
        'Erreur GitHub (HTTP $statusCode)${errorCode != null ? ' : $errorCode' : ''}',
      );

  final int statusCode;
  final String? errorCode;
}

/// Outcome of a single [GithubAuthService.pollOnce] attempt. GitHub answers
/// HTTP 200 with `{"error":"authorization_pending"}` while the user hasn't
/// approved yet — that is not an exception, just a "not yet" result.
class GithubPollResult {
  const GithubPollResult({this.accessToken, this.nextIntervalSeconds});

  /// Non-null when the user has approved the request.
  final String? accessToken;

  /// The interval (seconds) to wait before the next attempt when still
  /// pending — unchanged unless GitHub asked to slow down.
  final int? nextIntervalSeconds;

  bool get isSuccess => accessToken != null;
}

/// Contract for GitHub's OAuth Device Authorization Flow
/// (https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#device-flow).
/// Defined as an interface — even though only one real implementation makes
/// sense here — so `core/auth` depends on an abstraction, consistent with
/// every other service in `core/services/`.
///
/// [pollOnce] performs a single HTTP attempt with no internal sleeping —
/// `core/auth/auth_controller.dart` owns the timing (via a cancelable
/// `Timer`) so it can poll immediately when the app returns to the
/// foreground instead of waiting on a timer that may have been suspended
/// while backgrounded.
abstract interface class GithubAuthService {
  /// Step 1: requests a fresh [GithubDeviceCode] to start the flow.
  Future<GithubDeviceCode> requestDeviceCode();

  /// Step 2: one polling attempt for [deviceCode]. [currentInterval] is
  /// echoed back in [GithubPollResult.nextIntervalSeconds] unless GitHub's
  /// `slow_down` response says otherwise. Throws a [GithubAuthException] on
  /// a fatal response (expired, denied, or anything else GitHub rejects).
  Future<GithubPollResult> pollOnce(
    GithubDeviceCode deviceCode, {
    required int currentInterval,
  });
}

class GithubAuthServiceImpl implements GithubAuthService {
  GithubAuthServiceImpl({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _deviceCodeUrl = 'https://github.com/login/device/code';
  static const _accessTokenUrl = 'https://github.com/login/oauth/access_token';
  static const _headers = {
    'Accept': 'application/json',
    'User-Agent': githubUserAgent,
  };

  final http.Client _httpClient;

  @override
  Future<GithubDeviceCode> requestDeviceCode() async {
    final response = await _httpClient.post(
      Uri.parse(_deviceCodeUrl),
      headers: _headers,
      body: {'client_id': githubOAuthClientId, 'scope': 'repo workflow'},
    );
    _logResponse('device_code', response);

    final json = _tryDecodeJson(response.body);
    final deviceCode = json?['device_code'] as String?;
    if (response.statusCode != 200 || deviceCode == null) {
      throw GithubAuthRequestException(
        statusCode: response.statusCode,
        errorCode: (json?['error'] ?? json?['message']) as String?,
      );
    }

    return GithubDeviceCode(
      deviceCode: deviceCode,
      userCode: json!['user_code'] as String,
      verificationUri: json['verification_uri'] as String,
      expiresIn: json['expires_in'] as int,
      interval: json['interval'] as int,
    );
  }

  @override
  Future<GithubPollResult> pollOnce(
    GithubDeviceCode deviceCode, {
    required int currentInterval,
  }) async {
    final response = await _httpClient.post(
      Uri.parse(_accessTokenUrl),
      headers: _headers,
      body: {
        'client_id': githubOAuthClientId,
        'device_code': deviceCode.deviceCode,
        'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
      },
    );
    _logResponse('access_token', response);

    final json = _tryDecodeJson(response.body);
    if (json == null) {
      throw GithubAuthRequestException(statusCode: response.statusCode);
    }

    final error = json['error'] as String?;
    if (error == null) {
      final token = json['access_token'] as String?;
      if (token == null) {
        throw GithubAuthRequestException(
          statusCode: response.statusCode,
          errorCode: 'missing_access_token',
        );
      }
      return GithubPollResult(accessToken: token);
    }

    // authorization_pending: the user hasn't approved yet — HTTP 200, not
    // an error condition. Keep polling at the same interval.
    if (error == 'authorization_pending') {
      return GithubPollResult(nextIntervalSeconds: currentInterval);
    }
    if (error == 'slow_down') {
      // GitHub's OAuth spec: bump by 5s if it doesn't say the new value.
      final newInterval = (json['interval'] as int?) ?? (currentInterval + 5);
      return GithubPollResult(nextIntervalSeconds: newInterval);
    }
    if (error == 'expired_token') {
      throw const GithubAuthExpiredException();
    }
    if (error == 'access_denied') {
      throw const GithubAuthDeniedException();
    }
    // incorrect_device_code, or anything else GitHub might send: fatal,
    // surfaced with the raw error code.
    throw GithubAuthRequestException(
      statusCode: response.statusCode,
      errorCode: error,
    );
  }

  Map<String, dynamic>? _tryDecodeJson(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  void _logResponse(String label, http.Response response) {
    // Never log the token itself.
    final redactedBody = response.body.replaceAll(
      RegExp(r'"access_token"\s*:\s*"[^"]*"'),
      '"access_token":"***"',
    );
    debugPrint(
      '[GithubAuthService] $label -> HTTP ${response.statusCode}: $redactedBody',
    );
  }
}
