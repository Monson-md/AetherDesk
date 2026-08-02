import 'package:aetherdesk/core/services/github/github_device_code.dart';

/// The three states the app's GitHub session can be in, exactly as scoped
/// by the device flow: no session, a device code issued and awaiting the
/// user's authorization, or a stored access token.
enum AuthStatus { disconnected, pending, connected }

/// Auth state consumed by `login_page.dart` and the router's redirect
/// guard. Not a feature module's state — this gates the whole app, so it
/// lives in `core/auth`, alongside `core/theme` and `core/router`.
class AuthState {
  const AuthState({
    this.status = AuthStatus.disconnected,
    this.deviceCode,
    this.errorMessage,
  });

  final AuthStatus status;

  /// Set while [status] is [AuthStatus.pending] so the login screen can show
  /// the user code and "open GitHub" button.
  final GithubDeviceCode? deviceCode;

  /// Set when a login attempt failed (expired, denied, or a network error),
  /// cleared on the next attempt. Always paired with [AuthStatus.disconnected].
  final String? errorMessage;
}
