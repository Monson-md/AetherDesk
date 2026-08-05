import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';

/// Contract that any future security-tooling backend (a real threat-intel
/// API, a real port scanner, a real shell) must satisfy to power the
/// `cyber_workspace` module. Defining this now — with zero real network
/// access — lets the module be built against a stable abstraction; swapping
/// in real tools later only means writing a new [CyberToolsService]
/// implementation and registering it in `cyberToolsServiceProvider`.
/// Nothing in `features/cyber_workspace/domain/` or `presentation/` has to
/// change.
abstract interface class CyberToolsService {
  Future<IpAnalysisResult> analyzeIp(String ip);

  Future<UrlAnalysisResult> analyzeUrl(String url);

  Future<PortScanResult> scanPorts(String host, List<int> ports);

  /// Runs a single simulated shell [command] and returns its textual
  /// output, mirroring how a real (sandboxed) terminal backend would
  /// respond to one submitted line.
  Future<String> runCommand(String command);
}
