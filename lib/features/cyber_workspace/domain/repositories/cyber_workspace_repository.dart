import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/cyber_history_entry.dart';

/// Contract for the `cyber_workspace` module: runs each simulated tool via
/// the app-wide `CyberToolsService` and records every run as a
/// [CyberHistoryEntry] in a local, in-memory history log.
abstract interface class CyberWorkspaceRepository {
  Future<IpAnalysisResult> analyzeIp(String ip);

  Future<UrlAnalysisResult> analyzeUrl(String url);

  Future<PortScanResult> scanPorts(String host, List<int> ports);

  Future<String> runCommand(String command);

  List<CyberHistoryEntry> getHistory();

  CyberHistoryEntry setHistoryFavorite(
    String entryId, {
    required bool isFavorite,
  });

  void deleteHistoryEntry(String entryId);

  void clearHistory();
}
