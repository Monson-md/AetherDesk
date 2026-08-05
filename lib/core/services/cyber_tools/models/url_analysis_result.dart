/// Result of a real syntactic + reachability check of a URL, via
/// [CyberToolsService.analyzeUrl]. No content-category/threat data is
/// included — that would require a paid third-party API, which this app
/// doesn't call.
class UrlAnalysisResult {
  const UrlAnalysisResult({
    required this.url,
    required this.isValid,
    required this.scheme,
    required this.host,
    required this.isReachable,
    this.responseTime,
  });

  final String url;

  /// Whether [url] parses as a well-formed URI with a non-empty host.
  final bool isValid;
  final String scheme;
  final String host;

  /// Whether a real TCP connection could be opened to the host on the
  /// port implied by [scheme] (443 for https, 80 otherwise).
  final bool isReachable;
  final Duration? responseTime;
}
