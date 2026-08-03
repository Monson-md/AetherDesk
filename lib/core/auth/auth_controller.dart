import 'dart:async';
import 'dart:io';

import 'package:aetherdesk/core/auth/auth_state.dart';
import 'package:aetherdesk/core/services/github/github_auth_service.dart';
import 'package:aetherdesk/core/services/github/github_auth_service_provider.dart';
import 'package:aetherdesk/core/services/storage/secure_storage_service_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Orchestrates the GitHub device flow (via [GithubAuthService]) and token
/// persistence (via `SecureStorageService`), exposing only the three states
/// in [AuthStatus] to the rest of the app. This is what the router's
/// redirect guard and `login_page.dart` both watch.
///
/// Polling is driven by a cancelable [Timer] rather than a sleep loop
/// inside the service, specifically so [didChangeAppLifecycleState] can cut
/// a wait short and poll immediately the moment the app returns to the
/// foreground — the user leaves the app to approve the code in a browser,
/// and Android can throttle or suspend background timers in the meantime.
class AuthController extends Notifier<AuthState> with WidgetsBindingObserver {
  Timer? _pollTimer;
  DateTime? _pollDeadline;
  int _pollInterval = 5;
  int _consecutiveNetworkFailures = 0;

  /// The user is off approving the code in a browser while this polls —
  /// a dropped socket or a slow/absent connection is expected, not fatal.
  /// Only give up once it's happened this many times in a row.
  static const _maxConsecutiveNetworkFailures = 10;

  @override
  AuthState build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _pollTimer?.cancel();
    });
    Future.microtask(_restoreSession);
    return const AuthState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        this.state.status == AuthStatus.pending) {
      debugPrint(
        '[AuthController] Resumed while pending — polling immediately.',
      );
      _pollTimer?.cancel();
      _consecutiveNetworkFailures = 0;
      unawaited(_pollOnceAndReschedule());
    }
  }

  Future<void> _restoreSession() async {
    final token = await ref
        .read(secureStorageServiceProvider)
        .read(githubTokenStorageKey);
    if (token != null) {
      state = const AuthState(status: AuthStatus.connected);
    }
  }

  /// Runs the full device flow: request a code, show it (via [state]), then
  /// schedule polling. See [_pollOnceAndReschedule] for the polling itself.
  Future<void> login() async {
    _pollTimer?.cancel();
    state = const AuthState();

    try {
      final deviceCode = await ref
          .read(githubAuthServiceProvider)
          .requestDeviceCode();
      _pollInterval = deviceCode.interval;
      _pollDeadline = DateTime.now().add(
        Duration(seconds: deviceCode.expiresIn),
      );
      state = AuthState(status: AuthStatus.pending, deviceCode: deviceCode);
      _schedulePoll(Duration(seconds: _pollInterval));
    } on GithubAuthException catch (e) {
      state = AuthState(errorMessage: e.message);
    } catch (e) {
      state = AuthState(errorMessage: 'Erreur inattendue : $e');
    }
  }

  /// Fallback to the device flow: validates [token] against `GET /user`
  /// directly (it isn't stored yet, so `GithubApiClient` — which only ever
  /// reads the already-persisted token — can't be reused here), then
  /// persists it exactly like [login] does. Once stored, the rest of the
  /// app can't tell which flow produced the token.
  Future<void> loginWithPersonalAccessToken(String token) async {
    _pollTimer?.cancel();
    state = const AuthState();

    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/user'),
        headers: {
          'Accept': 'application/vnd.github+json',
          'User-Agent': githubUserAgent,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await ref
            .read(secureStorageServiceProvider)
            .write(githubTokenStorageKey, token);
        state = const AuthState(status: AuthStatus.connected);
      } else if (response.statusCode == 401) {
        state = const AuthState(errorMessage: 'Jeton invalide ou expiré.');
      } else {
        state = AuthState(
          errorMessage: 'Erreur GitHub (HTTP ${response.statusCode}).',
        );
      }
    } catch (e) {
      state = AuthState(errorMessage: 'Erreur inattendue : $e');
    }
  }

  void _schedulePoll(Duration delay) {
    _pollTimer?.cancel();
    _pollTimer = Timer(delay, () => unawaited(_pollOnceAndReschedule()));
  }

  Future<void> _pollOnceAndReschedule() async {
    final deviceCode = state.deviceCode;
    final deadline = _pollDeadline;
    if (state.status != AuthStatus.pending ||
        deviceCode == null ||
        deadline == null) {
      return;
    }
    if (DateTime.now().isAfter(deadline)) {
      state = const AuthState(
        errorMessage: 'Le code a expiré, veuillez recommencer.',
      );
      return;
    }

    try {
      final result = await ref
          .read(githubAuthServiceProvider)
          .pollOnce(deviceCode, currentInterval: _pollInterval);
      _consecutiveNetworkFailures = 0;

      if (result.isSuccess) {
        await ref
            .read(secureStorageServiceProvider)
            .write(githubTokenStorageKey, result.accessToken!);
        state = const AuthState(status: AuthStatus.connected);
        return;
      }

      _pollInterval = result.nextIntervalSeconds ?? _pollInterval;
      if (state.status == AuthStatus.pending) {
        _schedulePoll(Duration(seconds: _pollInterval));
      }
    } on GithubAuthException catch (e) {
      state = AuthState(errorMessage: e.message);
    } on http.ClientException catch (e) {
      _handleTransientPollError('ClientException: $e');
    } on SocketException catch (e) {
      _handleTransientPollError('SocketException: $e');
    } on HandshakeException catch (e) {
      _handleTransientPollError('HandshakeException: $e');
    } on TimeoutException catch (e) {
      _handleTransientPollError('TimeoutException: $e');
    } catch (e) {
      state = AuthState(errorMessage: 'Erreur inattendue : $e');
    }
  }

  /// A transient network error (dropped socket, timeout…) while polling —
  /// expected while the app is backgrounded and not itself a reason to
  /// stop. Only surfaced to the user after too many in a row.
  void _handleTransientPollError(String detail) {
    _consecutiveNetworkFailures++;
    debugPrint(
      '[AuthController] Transient poll error '
      '($_consecutiveNetworkFailures/$_maxConsecutiveNetworkFailures): $detail',
    );
    if (_consecutiveNetworkFailures >= _maxConsecutiveNetworkFailures) {
      state = const AuthState(
        errorMessage:
            'Connexion instable : impossible de contacter GitHub. '
            'Vérifiez votre connexion et réessayez.',
      );
      return;
    }
    if (state.status == AuthStatus.pending) {
      _schedulePoll(Duration(seconds: _pollInterval));
    }
  }

  /// Clears the stored token. Called from the profile screen's "déconnexion"
  /// button, and automatically by [GithubApiClient] on a 401.
  Future<void> logout() async {
    _pollTimer?.cancel();
    await ref.read(secureStorageServiceProvider).delete(githubTokenStorageKey);
    state = const AuthState();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
