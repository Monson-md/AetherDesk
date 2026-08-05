import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';

/// Contract for the `cyber_workspace` module's network diagnostic tools.
/// `RealCyberToolsService` implements this with genuine `dart:io` sockets
/// and DNS lookups — real, but limited to what's honestly answerable
/// without a paid threat-intelligence API or a custom backend (no
/// geolocation/ISP/malware-category data). This is still the swap point:
/// a future implementation (e.g. backed by a real threat-intel API) only
/// means registering a new provider in `cyberToolsServiceProvider`; nothing
/// in `features/cyber_workspace/domain/` or `presentation/` has to change.
abstract interface class CyberToolsService {
  Future<IpAnalysisResult> analyzeIp(String host);

  Future<UrlAnalysisResult> analyzeUrl(String url);

  Future<PortScanResult> scanPorts(String host, List<int> ports);

  /// Runs a single terminal [command] and returns its textual output. Real
  /// where it can honestly be (network reachability, real local interface
  /// info) — see `RealCyberToolsService.runCommand`.
  Future<String> runCommand(String command);
}
