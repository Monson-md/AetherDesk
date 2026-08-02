import 'package:aetherdesk/core/router/app_shell.dart';
import 'package:aetherdesk/core/router/dashboard_overview_page.dart';
import 'package:aetherdesk/core/router/route_guards.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/pages/ai_assistant_home_page.dart';
import 'package:aetherdesk/features/code_editor/presentation/pages/code_editor_home_page.dart';
import 'package:aetherdesk/features/creation_2d/presentation/pages/creation_2d_home_page.dart';
import 'package:aetherdesk/features/creation_3d/presentation/pages/creation_3d_home_page.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/pages/cyber_workspace_home_page.dart';
import 'package:aetherdesk/features/project_management/presentation/pages/project_management_home_page.dart';
import 'package:aetherdesk/features/secure_vault/presentation/pages/secure_vault_home_page.dart';
import 'package:aetherdesk/features/settings/presentation/pages/settings_home_page.dart';
import 'package:aetherdesk/features/user_profile/presentation/pages/user_profile_home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Single source of truth for navigation. Every module gets exactly one
/// top-level route here; deeper in-module navigation (e.g. opening a
/// specific project) should live under that module's own nested routes as
/// it's built out, not by growing this file indefinitely.
///
/// To add a new module: add a path to [RoutePaths], an entry to
/// `buildNavDestinations` in `nav_destinations.dart` (icon, label, accent
/// color), a `<module>_home_page.dart` under its `presentation/pages/`
/// using `ModulePlaceholderPage` + `destinationFor`, then one `GoRoute`
/// below. The rail, drawer and dashboard grid pick it up automatically.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.dashboard,
    redirect: authRedirectGuard,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.dashboard,
            builder: (context, state) => const DashboardOverviewPage(),
          ),
          GoRoute(
            path: RoutePaths.aiAssistant,
            builder: (context, state) => const AiAssistantHomePage(),
          ),
          GoRoute(
            path: RoutePaths.codeEditor,
            builder: (context, state) => const CodeEditorHomePage(),
          ),
          GoRoute(
            path: RoutePaths.projectManagement,
            builder: (context, state) => const ProjectManagementHomePage(),
          ),
          GoRoute(
            path: RoutePaths.secureVault,
            builder: (context, state) => const SecureVaultHomePage(),
          ),
          GoRoute(
            path: RoutePaths.cyberWorkspace,
            builder: (context, state) => const CyberWorkspaceHomePage(),
          ),
          GoRoute(
            path: RoutePaths.creation2d,
            builder: (context, state) => const Creation2dHomePage(),
          ),
          GoRoute(
            path: RoutePaths.creation3d,
            builder: (context, state) => const Creation3dHomePage(),
          ),
          GoRoute(
            path: RoutePaths.settings,
            builder: (context, state) => const SettingsHomePage(),
          ),
          GoRoute(
            path: RoutePaths.userProfile,
            builder: (context, state) => const UserProfileHomePage(),
          ),
        ],
      ),
    ],
  );
});
