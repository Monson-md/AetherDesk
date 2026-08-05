/// Result of looking up a single IP address via [CyberToolsService.analyzeIp].
class IpAnalysisResult {
  const IpAnalysisResult({
    required this.ip,
    required this.country,
    required this.isp,
    required this.riskScore,
    required this.isSuspicious,
  });

  final String ip;
  final String country;
  final String isp;

  /// 0 (safe) to 100 (high risk) — simulated, not a real reputation score.
  final int riskScore;
  final bool isSuspicious;
}
