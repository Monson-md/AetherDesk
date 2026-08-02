import 'package:aetherdesk/core/auth/auth_state.dart';
import 'package:aetherdesk/core/services/github/github_auth_service.dart';
import 'package:aetherdesk/core/services/github/github_auth_service_provider.dart';
import 'package:aetherdesk/core/services/storage/secure_storage_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Orchestrates the GitHub device flow (via [GithubAuthService]) and token
/// persistence (via `SecureStorageService`), exposing only the three states
/// in [AuthStatus] to the rest of the app. This is what the router's
/// redirect guard and `login_page.dart` both watch.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(_restoreSession);
    return const AuthState();
  }

  Future<void> _restoreSession() async {
    final token = await ref
        .read(secureStorageServiceProvider)
        .read(githubTokenStorageKey);
    if (token != null) {
      state = const AuthState(status: AuthStatus.connected);
    }
  }

  /// Runs the full device flow: request a code, show it (via [state]) while
  /// polling, then persist the token on success.
  Future<void> login() async {
    state = const AuthState();
    final authService = ref.read(githubAuthServiceProvider);

    try {
      final deviceCode = await authService.requestDeviceCode();
      state = AuthState(status: AuthStatus.pending, deviceCode: deviceCode);

      final token = await authService.pollForAccessToken(deviceCode);
      await ref
          .read(secureStorageServiceProvider)
          .write(githubTokenStorageKey, token);
      state = const AuthState(status: AuthStatus.connected);
    } on GithubAuthException catch (e) {
      state = AuthState(errorMessage: e.message);
    } catch (_) {
      state = const AuthState(
        errorMessage:
            'Impossible de se connecter. Vérifiez votre connexion internet.',
      );
    }
  }

  /// Clears the stored token. Called from the profile screen's "déconnexion"
  /// button, and automatically by [GithubApiClient] on a 401.
  Future<void> logout() async {
    await ref.read(secureStorageServiceProvider).delete(githubTokenStorageKey);
    state = const AuthState();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
