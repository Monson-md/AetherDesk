import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Placeholder for future route protection (e.g. redirect to a login screen
/// if the user isn't authenticated, or lock `secure_vault` behind biometric
/// confirmation).
///
/// Wired into `GoRouter.redirect` in `app_router.dart` but always returns
/// `null` (no redirect) today, since no auth system exists yet. Implement
/// the actual check here once one does — no call site changes.
String? authRedirectGuard(BuildContext context, GoRouterState state) {
  return null;
}
