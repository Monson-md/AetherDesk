import 'dart:async';
import 'dart:io';

import 'package:aetherdesk/core/services/cyber_tools/cyber_tools_service.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';

/// Real, `dart:io`-backed [CyberToolsService]: genuine DNS lookups and TCP
/// connection attempts, no fabricated geolocation/ISP/threat data. See
/// [CyberToolsService]'s doc comment for what's intentionally left out and
/// why.
class RealCyberToolsService implements CyberToolsService {
  const RealCyberToolsService();

  static const _connectTimeout = Duration(seconds: 3);

  static const _commonPorts = {
    21: 'FTP',
    22: 'SSH',
    23: 'Telnet',
    25: 'SMTP',
    53: 'DNS',
    80: 'HTTP',
    110: 'POP3',
    143: 'IMAP',
    443: 'HTTPS',
    3306: 'MySQL',
    3389: 'RDP',
    5432: 'PostgreSQL',
    8080: 'HTTP-Alt',
  };

  Future<Duration?> _tryConnect(String host, int port) async {
    final stopwatch = Stopwatch()..start();
    try {
      final socket = await Socket.connect(host, port, timeout: _connectTimeout);
      stopwatch.stop();
      unawaited(socket.close());
      return stopwatch.elapsed;
    } on Exception {
      return null;
    }
  }

  @override
  Future<IpAnalysisResult> analyzeIp(String host) async {
    final trimmed = host.trim();
    var addresses = const <InternetAddress>[];
    try {
      addresses = await InternetAddress.lookup(trimmed);
    } on Exception {
      addresses = const [];
    }
    Duration? responseTime;
    if (addresses.isNotEmpty) {
      responseTime =
          await _tryConnect(trimmed, 443) ?? await _tryConnect(trimmed, 80);
    }
    return IpAnalysisResult(
      host: trimmed,
      resolvedAddresses: addresses.map((address) => address.address).toList(),
      isReachable: responseTime != null,
      responseTime: responseTime,
    );
  }

  @override
  Future<UrlAnalysisResult> analyzeUrl(String url) async {
    final trimmed = url.trim();
    final uri = Uri.tryParse(
      trimmed.contains('://') ? trimmed : 'https://$trimmed',
    );
    if (uri == null || uri.host.isEmpty) {
      return UrlAnalysisResult(
        url: trimmed,
        isValid: false,
        scheme: '',
        host: '',
        isReachable: false,
      );
    }
    final port = uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80);
    final responseTime = await _tryConnect(uri.host, port);
    return UrlAnalysisResult(
      url: trimmed,
      isValid: true,
      scheme: uri.scheme,
      host: uri.host,
      isReachable: responseTime != null,
      responseTime: responseTime,
    );
  }

  @override
  Future<PortScanResult> scanPorts(String host, List<int> ports) async {
    final trimmed = host.trim();
    final entries = <PortScanEntry>[];
    for (final port in ports) {
      final responseTime = await _tryConnect(trimmed, port);
      entries.add(
        PortScanEntry(
          port: port,
          isOpen: responseTime != null,
          service: _commonPorts[port] ?? 'Unknown',
        ),
      );
    }
    return PortScanResult(host: trimmed, entries: entries);
  }

  @override
  Future<String> runCommand(String command) async {
    final trimmed = command.trim();
    if (trimmed.isEmpty) return '';
    final firstWord = trimmed.split(' ').first.toLowerCase();
    final rest = trimmed.substring(firstWord.length).trim();

    switch (firstWord) {
      case 'help':
        return 'Available commands: help, whoami, ping <host>, ifconfig, '
            'echo <text>, clear';
      case 'whoami':
        return Platform.environment['USER'] ??
            Platform.environment['USERNAME'] ??
            Platform.localHostname;
      case 'ping':
        return _ping(rest.isEmpty ? 'localhost' : rest);
      case 'ifconfig':
      case 'ipconfig':
        return _ifconfig();
      case 'echo':
        return rest;
      case 'clear':
        return '';
      default:
        return "Command not found: '$firstWord'. Type 'help' for a list.";
    }
  }

  Future<String> _ping(String host) async {
    final responseTime =
        await _tryConnect(host, 443) ?? await _tryConnect(host, 80);
    if (responseTime == null) {
      return 'Could not reach $host (no response on ports 443/80).';
    }
    return 'Connected to $host in ${responseTime.inMilliseconds}ms '
        '(real TCP handshake, not ICMP).';
  }

  Future<String> _ifconfig() async {
    final interfaces = await NetworkInterface.list();
    if (interfaces.isEmpty) return 'No network interfaces found.';
    final buffer = StringBuffer();
    for (final interface in interfaces) {
      for (final address in interface.addresses) {
        buffer.writeln('${interface.name}: inet ${address.address}');
      }
    }
    return buffer.toString().trimRight();
  }
}
