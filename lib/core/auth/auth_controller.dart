import 'dart:async';

import 'package:aetherdesk/core/auth/auth_state.dart';
import 'package:aetherdesk/core/services/github/github_auth_service.dart';
import 'package:aetherdesk/core/services/github/github_auth_service_provider.dart';
import 'package:aetherdesk/core/services/storage/secure_storage_service_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    } catch (e) {
      state = AuthState(errorMessage: 'Erreur inattendue : $e');
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
