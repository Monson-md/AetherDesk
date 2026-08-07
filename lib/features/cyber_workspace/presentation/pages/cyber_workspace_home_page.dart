import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/cyber_history_entry.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/network_tool_type.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/providers/cyber_workspace_controller.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/ble_scanner_section.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/dashboard_stat_card.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/flashlight_section.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/history_entry_tile.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/history_filter_bar.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/ip_analysis_section.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/port_scanner_section.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/qr_tool_section.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/sensors_section.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/terminal_view.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/url_analysis_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `cyber_workspace` module: a dashboard summary plus
/// three tabs for the simulated tools (IP/URL/port scan, terminal) and a
/// history log — see `core/services/cyber_tools/`'s doc comment for how
/// the simulations are wired so they can be swapped for real tools later.
class CyberWorkspaceHomePage extends ConsumerStatefulWidget {
  const CyberWorkspaceHomePage({super.key});

  @override
  ConsumerState<CyberWorkspaceHomePage> createState() =>
      _CyberWorkspaceHomePageState();
}

class _CyberWorkspaceHomePageState extends ConsumerState<CyberWorkspaceHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 5,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _jumpTo(int index) => _tabController.animateTo(index);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.cyberWorkspace);
    final state = ref.watch(cyberWorkspaceControllerProvider);
    final controller = ref.read(cyberWorkspaceControllerProvider.notifier);
    final filteredHistory = ref.watch(filteredHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(destination.label),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.dashboard_outlined),
              text: l10n.cyberWorkspaceTabDashboard,
            ),
            Tab(
              icon: const Icon(Icons.security_outlined),
              text: l10n.cyberWorkspaceTabTools,
            ),
            Tab(
              icon: const Icon(Icons.terminal_outlined),
              text: l10n.cyberWorkspaceTabTerminal,
            ),
            Tab(
              icon: const Icon(Icons.history_outlined),
              text: l10n.cyberWorkspaceTabHistory,
            ),
            Tab(
              icon: const Icon(Icons.memory_outlined),
              text: l10n.cyberWorkspaceTabDevice,
            ),
          ],
        ),
      ),
      body: ResponsiveContentWrapper(
        child: TabBarView(
          controller: _tabController,
          children: [
            _DashboardTab(state: state, onJumpTo: _jumpTo),
            _ToolsTab(state: state, controller: controller),
            _TerminalTab(state: state, controller: controller),
            _HistoryTab(
              history: filteredHistory,
              favoritesOnly: state.historyFavoritesOnly,
              selectedToolType: state.historyToolFilter,
              controller: controller,
            ),
            const _DeviceTab(),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({required this.state, required this.onJumpTo});

  final CyberWorkspaceState state;
  final ValueChanged<int> onJumpTo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final favoritesCount = state.history.where((e) => e.isFavorite).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cyberWorkspaceDashboardTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Wrap(
            spacing: AppDimensions.spacingMd,
            runSpacing: AppDimensions.spacingMd,
            children: [
              DashboardStatCard(
                icon: Icons.history_outlined,
                value: '${state.history.length}',
                label: l10n.cyberWorkspaceStatTotalRuns,
              ),
              DashboardStatCard(
                icon: Icons.star_outline,
                value: '$favoritesCount',
                label: l10n.cyberWorkspaceStatFavorites,
                color: Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            l10n.cyberWorkspaceQuickActionsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.security_outlined),
                label: Text(l10n.cyberWorkspaceTabTools),
                onPressed: () => onJumpTo(1),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.terminal_outlined),
                label: Text(l10n.cyberWorkspaceTabTerminal),
                onPressed: () => onJumpTo(2),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.history_outlined),
                label: Text(l10n.cyberWorkspaceTabHistory),
                onPressed: () => onJumpTo(3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolsTab extends StatelessWidget {
  const _ToolsTab({required this.state, required this.controller});

  final CyberWorkspaceState state;
  final CyberWorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      children: [
        IpAnalysisSection(
          isRunning: state.isRunning,
          result: state.lastIpResult,
          onAnalyze: controller.analyzeIp,
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        UrlAnalysisSection(
          isRunning: state.isRunning,
          result: state.lastUrlResult,
          onAnalyze: controller.analyzeUrl,
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        PortScannerSection(
          isRunning: state.isRunning,
          result: state.lastPortScanResult,
          onScan: controller.scanPorts,
        ),
      ],
    );
  }
}

class _TerminalTab extends StatelessWidget {
  const _TerminalTab({required this.state, required this.controller});

  final CyberWorkspaceState state;
  final CyberWorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: TerminalView(
        lines: state.terminalLines,
        onSubmit: controller.runTerminalCommand,
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({
    required this.history,
    required this.favoritesOnly,
    required this.selectedToolType,
    required this.controller,
  });

  final List<CyberHistoryEntry> history;
  final bool favoritesOnly;
  final NetworkToolType? selectedToolType;
  final CyberWorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: HistoryFilterBar(
                  favoritesOnly: favoritesOnly,
                  onFavoritesOnlyChanged: controller.setHistoryFavoritesOnly,
                  selectedToolType: selectedToolType,
                  onToolTypeChanged: controller.setHistoryToolFilter,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: l10n.cyberWorkspaceClearHistory,
                onPressed: history.isEmpty ? null : controller.clearHistory,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Expanded(
            child: history.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.history_outlined,
                    title: l10n.cyberWorkspaceEmptyHistoryTitle,
                    message: l10n.cyberWorkspaceEmptyHistoryMessage,
                  )
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final entry = history[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spacingSm,
                        ),
                        child: HistoryEntryTile(
                          entry: entry,
                          onFavoriteToggle: () =>
                              controller.toggleHistoryFavorite(
                                entry.id,
                                isFavorite: !entry.isFavorite,
                              ),
                          onDelete: () =>
                              controller.deleteHistoryEntry(entry.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DeviceTab extends StatelessWidget {
  const _DeviceTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      children: const [
        SensorsSection(),
        SizedBox(height: AppDimensions.spacingMd),
        FlashlightSection(),
        SizedBox(height: AppDimensions.spacingMd),
        QrToolSection(),
        SizedBox(height: AppDimensions.spacingMd),
        BleScannerSection(),
      ],
    );
  }
}
