import 'package:aetherdesk/core/services/cyber_tools/cyber_tools_service.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/cyber_history_entry.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/network_tool_type.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/repositories/cyber_workspace_repository.dart';

/// Adapts the module's [CyberWorkspaceRepository] contract onto the
/// app-wide [CyberToolsService] — this is the seam: swap what
/// `cyberToolsServiceProvider` resolves to (real `dart:io` sockets today, a
/// full threat-intel backend later) and this class stays exactly the same.
/// The local, in-memory [_history] log is this module's own state, kept
/// here rather than in `presentation/` for the same reason every other
/// module keeps its collections in its repository.
class CyberWorkspaceRepositoryImpl implements CyberWorkspaceRepository {
  CyberWorkspaceRepositoryImpl(this._cyberToolsService);

  final CyberToolsService _cyberToolsService;
  final List<CyberHistoryEntry> _history = [];
  int _historyIdCounter = 0;

  @override
  Future<IpAnalysisResult> analyzeIp(String ip) async {
    final result = await _cyberToolsService.analyzeIp(ip);
    _record(
      toolType: NetworkToolType.ipAnalysis,
      query: ip,
      resultSummary: result.isReachable
          ? '${result.resolvedAddresses.join(', ')} · reachable'
          : 'unreachable',
    );
    return result;
  }

  @override
  Future<UrlAnalysisResult> analyzeUrl(String url) async {
    final result = await _cyberToolsService.analyzeUrl(url);
    _record(
      toolType: NetworkToolType.urlAnalysis,
      query: url,
      resultSummary: !result.isValid
          ? 'invalid URL'
          : result.isReachable
          ? '${result.host} · reachable'
          : '${result.host} · unreachable',
    );
    return result;
  }

  @override
  Future<PortScanResult> scanPorts(String host, List<int> ports) async {
    final result = await _cyberToolsService.scanPorts(host, ports);
    _record(
      toolType: NetworkToolType.portScan,
      query: host,
      resultSummary: '${result.openCount}/${result.entries.length} ports open',
    );
    return result;
  }

  @override
  Future<String> runCommand(String command) async {
    final output = await _cyberToolsService.runCommand(command);
    if (command.trim().isNotEmpty) {
      _record(
        toolType: NetworkToolType.terminal,
        query: command,
        resultSummary: output.isEmpty
            ? '(no output)'
            : output.split('\n').first,
      );
    }
    return output;
  }

  @override
  List<CyberHistoryEntry> getHistory() => List.unmodifiable(_history.reversed);

  @override
  CyberHistoryEntry setHistoryFavorite(
    String entryId, {
    required bool isFavorite,
  }) {
    final index = _history.indexWhere((entry) => entry.id == entryId);
    final updated = _history[index].copyWith(isFavorite: isFavorite);
    _history[index] = updated;
    return updated;
  }

  @override
  void deleteHistoryEntry(String entryId) {
    _history.removeWhere((entry) => entry.id == entryId);
  }

  @override
  void clearHistory() {
    _history.clear();
  }

  void _record({
    required NetworkToolType toolType,
    required String query,
    required String resultSummary,
  }) {
    _history.add(
      CyberHistoryEntry(
        id: 'history-${++_historyIdCounter}',
        toolType: toolType,
        query: query,
        resultSummary: resultSummary,
        timestamp: DateTime.now(),
        isFavorite: false,
      ),
    );
  }
}
