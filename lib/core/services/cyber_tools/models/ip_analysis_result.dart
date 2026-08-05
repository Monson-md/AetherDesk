/// Result of a real DNS/reachability lookup for a host, via
/// [CyberToolsService.analyzeIp]. No geolocation/ISP/threat data is
/// included — that would require a paid third-party API, which this app
/// doesn't call.
class IpAnalysisResult {
  const IpAnalysisResult({
    required this.host,
    required this.resolvedAddresses,
    required this.isReachable,
    this.responseTime,
  });

  final String host;

  /// Every IP address the host's DNS record resolves to (empty if
  /// resolution failed).
  final List<String> resolvedAddresses;

  /// Whether a real TCP connection could be opened to a common port
  /// (443/80) on the resolved host.
  final bool isReachable;

  /// Round-trip time of the successful connection attempt, if reachable.
  final Duration? responseTime;
}
