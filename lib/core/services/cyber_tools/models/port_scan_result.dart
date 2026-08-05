/// State of a single port checked during [CyberToolsService.scanPorts].
class PortScanEntry {
  const PortScanEntry({
    required this.port,
    required this.isOpen,
    required this.service,
  });

  final int port;
  final bool isOpen;

  /// Commonly-associated service name for [port] (e.g. "HTTPS" for 443),
  /// shown regardless of [isOpen] for reference.
  final String service;
}

/// Result of scanning a set of ports on [host] via
/// [CyberToolsService.scanPorts].
class PortScanResult {
  const PortScanResult({required this.host, required this.entries});

  final String host;
  final List<PortScanEntry> entries;

  int get openCount => entries.where((entry) => entry.isOpen).length;
}
