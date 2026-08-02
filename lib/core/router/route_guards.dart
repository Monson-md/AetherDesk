import 'package:aetherdesk/core/auth/auth_controller.dart';
import 'package:aetherdesk/core/auth/auth_state.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Redirects to [RoutePaths.login] whenever the app isn't connected to
/// GitHub, and away from it once it is. Wired into `GoRouter.redirect` in
/// `app_router.dart`; reads the current [AuthState] via
/// `ProviderScope.containerOf(context)` so the router's `redirect:`
/// signature never needs to change to accommodate whichever auth mechanism
/// exists — only this function's body does.
String? authRedirectGuard(BuildContext context, GoRouterState state) {
  final authStatus = ProviderScope.containerOf(
    context,
  ).read(authControllerProvider).status;
  final isOnLoginPage = state.matchedLocation == RoutePaths.login;

  if (authStatus != AuthStatus.connected) {
    return isOnLoginPage ? null : RoutePaths.login;
  }
  if (isOnLoginPage) {
    return RoutePaths.dashboard;
  }
  return null;
}
