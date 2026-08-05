import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/cyber_history_entry.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/network_tool_type.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/providers/cyber_workspace_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CyberWorkspaceState {
  const CyberWorkspaceState({
    this.history = const [],
    this.isRunning = false,
    this.lastIpResult,
    this.lastUrlResult,
    this.lastPortScanResult,
    this.terminalLines = const [],
    this.historyFavoritesOnly = false,
    this.historyToolFilter,
  });

  final List<CyberHistoryEntry> history;
  final bool isRunning;
  final IpAnalysisResult? lastIpResult;
  final UrlAnalysisResult? lastUrlResult;
  final PortScanResult? lastPortScanResult;
  final List<String> terminalLines;
  final bool historyFavoritesOnly;
  final NetworkToolType? historyToolFilter;

  CyberWorkspaceState copyWith({
    List<CyberHistoryEntry>? history,
    bool? isRunning,
    IpAnalysisResult? lastIpResult,
    UrlAnalysisResult? lastUrlResult,
    PortScanResult? lastPortScanResult,
    List<String>? terminalLines,
    bool? historyFavoritesOnly,
    NetworkToolType? historyToolFilter,
    bool clearHistoryToolFilter = false,
  }) {
    return CyberWorkspaceState(
      history: history ?? this.history,
      isRunning: isRunning ?? this.isRunning,
      lastIpResult: lastIpResult ?? this.lastIpResult,
      lastUrlResult: lastUrlResult ?? this.lastUrlResult,
      lastPortScanResult: lastPortScanResult ?? this.lastPortScanResult,
      terminalLines: terminalLines ?? this.terminalLines,
      historyFavoritesOnly: historyFavoritesOnly ?? this.historyFavoritesOnly,
      historyToolFilter: clearHistoryToolFilter
          ? null
          : (historyToolFilter ?? this.historyToolFilter),
    );
  }
}

/// Screen state for the whole `cyber_workspace` module: results of the last
/// run of each tool, the terminal's scrollback buffer, and the history log
/// with its favorites/tool-type filters.
class CyberWorkspaceController extends Notifier<CyberWorkspaceState> {
  @override
  CyberWorkspaceState build() {
    final repository = ref.read(cyberWorkspaceRepositoryProvider);
    return CyberWorkspaceState(history: repository.getHistory());
  }

  Future<void> analyzeIp(String ip) async {
    if (ip.trim().isEmpty) return;
    state = state.copyWith(isRunning: true);
    final result = await ref.read(analyzeIpUseCaseProvider).call(ip.trim());
    state = state.copyWith(
      isRunning: false,
      lastIpResult: result,
      history: ref.read(cyberWorkspaceRepositoryProvider).getHistory(),
    );
  }

  Future<void> analyzeUrl(String url) async {
    if (url.trim().isEmpty) return;
    state = state.copyWith(isRunning: true);
    final result = await ref.read(analyzeUrlUseCaseProvider).call(url.trim());
    state = state.copyWith(
      isRunning: false,
      lastUrlResult: result,
      history: ref.read(cyberWorkspaceRepositoryProvider).getHistory(),
    );
  }

  Future<void> scanPorts(String host, List<int> ports) async {
    if (host.trim().isEmpty || ports.isEmpty) return;
    state = state.copyWith(isRunning: true);
    final result = await ref
        .read(scanPortsUseCaseProvider)
        .call(host.trim(), ports);
    state = state.copyWith(
      isRunning: false,
      lastPortScanResult: result,
      history: ref.read(cyberWorkspaceRepositoryProvider).getHistory(),
    );
  }

  Future<void> runTerminalCommand(String command) async {
    final trimmed = command.trim();
    if (trimmed.isEmpty) return;
    if (trimmed.toLowerCase() == 'clear') {
      state = state.copyWith(terminalLines: const []);
      return;
    }
    state = state.copyWith(
      terminalLines: [...state.terminalLines, '> $trimmed'],
    );
    final output = await ref
        .read(runTerminalCommandUseCaseProvider)
        .call(trimmed);
    state = state.copyWith(
      terminalLines: [
        ...state.terminalLines,
        if (output.isNotEmpty) ...output.split('\n'),
      ],
      history: ref.read(cyberWorkspaceRepositoryProvider).getHistory(),
    );
  }

  void toggleHistoryFavorite(String entryId, {required bool isFavorite}) {
    ref
        .read(setHistoryFavoriteUseCaseProvider)
        .call(entryId, isFavorite: isFavorite);
    state = state.copyWith(
      history: ref.read(cyberWorkspaceRepositoryProvider).getHistory(),
    );
  }

  void deleteHistoryEntry(String entryId) {
    ref.read(deleteHistoryEntryUseCaseProvider).call(entryId);
    state = state.copyWith(
      history: ref.read(cyberWorkspaceRepositoryProvider).getHistory(),
    );
  }

  void clearHistory() {
    ref.read(clearHistoryUseCaseProvider).call();
    state = state.copyWith(history: const []);
  }

  void setHistoryFavoritesOnly(bool value) {
    state = state.copyWith(historyFavoritesOnly: value);
  }

  void setHistoryToolFilter(NetworkToolType? toolType) {
    state = state.copyWith(
      historyToolFilter: toolType,
      clearHistoryToolFilter: toolType == null,
    );
  }
}

final cyberWorkspaceControllerProvider =
    NotifierProvider<CyberWorkspaceController, CyberWorkspaceState>(
      CyberWorkspaceController.new,
    );

/// Derived, read-only view of [cyberWorkspaceControllerProvider]'s history
/// after applying the current favorites/tool-type filters.
final filteredHistoryProvider = Provider<List<CyberHistoryEntry>>((ref) {
  final state = ref.watch(cyberWorkspaceControllerProvider);
  return state.history.where((entry) {
    if (state.historyFavoritesOnly && !entry.isFavorite) return false;
    if (state.historyToolFilter != null &&
        entry.toolType != state.historyToolFilter) {
      return false;
    }
    return true;
  }).toList();
});
