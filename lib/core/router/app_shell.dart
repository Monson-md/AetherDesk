import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/theme/app_theme.dart';
import 'package:aetherdesk/core/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Persistent navigation frame wrapped around every route by `app_router.dart`
/// via `ShellRoute`. Uses a [NavigationRail] on wide (desktop/tablet) windows
/// and a [Drawer] on narrow (phone) ones, since AetherDesk is meant to work
/// as a multi-module desktop-style workspace as well as a phone app.
///
/// A Bottom Navigation Bar was deliberately not used: with 9 modules it
/// would either overflow or need a "more" overflow menu, which hurts
/// discoverability rather than helping it. The rail/drawer pair scales to
/// this many destinations without that trade-off.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const double _wideLayoutBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destinations = buildNavDestinations(l10n);
    final currentPath = GoRouterState.of(context).uri.toString();
    final selectedIndex = destinations.indexWhere((d) => d.path == currentPath);

    final isWide = MediaQuery.sizeOf(context).width >= _wideLayoutBreakpoint;

    void onDestinationSelected(int index) {
      context.go(destinations[index].path);
    }

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: MediaQuery.sizeOf(context).width >= 1100,
              selectedIndex: selectedIndex < 0 ? null : selectedIndex,
              onDestinationSelected: onDestinationSelected,
              leading: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacingMd,
                ),
                child: IconButton(
                  icon: const Icon(Icons.dashboard_outlined),
                  tooltip: l10n.navDashboard,
                  onPressed: () => context.go(RoutePaths.dashboard),
                ),
              ),
              trailing: const Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.spacingMd,
                    ),
                    child: _ThemeToggleButton(),
                  ),
                ),
              ),
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [_ThemeToggleButton()],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard_outlined),
                title: Text(l10n.navDashboard),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(RoutePaths.dashboard);
                },
              ),
              for (final d in destinations)
                ListTile(
                  leading: Icon(d.icon),
                  title: Text(d.label),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go(d.path);
                  },
                ),
            ],
          ),
        ),
      ),
      body: child,
    );
  }
}

/// Light/dark toggle, the one genuinely useful bit of interactive chrome
/// this navigation shell needs today. Wired to [themeModeProvider] — the
/// only piece of app-wide state that exists before any module has real
/// business logic.
class _ThemeToggleButton extends ConsumerWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDarkMode;
    return IconButton(
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      tooltip: isDark ? 'Light mode' : 'Dark mode',
      onPressed: () => ref.read(themeModeProvider.notifier).toggleLightDark(),
    );
  }
}
