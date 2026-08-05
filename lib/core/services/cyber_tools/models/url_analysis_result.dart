/// Result of checking a single URL via [CyberToolsService.analyzeUrl].
class UrlAnalysisResult {
  const UrlAnalysisResult({
    required this.url,
    required this.category,
    required this.riskScore,
    required this.isSafe,
  });

  final String url;

  /// Simulated content category (e.g. "Technology", "Suspicious").
  final String category;

  /// 0 (safe) to 100 (high risk) — simulated, not a real reputation score.
  final int riskScore;
  final bool isSafe;
}
