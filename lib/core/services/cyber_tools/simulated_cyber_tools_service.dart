import 'dart:math';

import 'package:aetherdesk/core/services/cyber_tools/cyber_tools_service.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';

/// Local, fully offline stand-in for [CyberToolsService]. No socket is
/// opened, no request is sent anywhere — every result is derived
/// deterministically from the input's hash (so repeating the same query
/// gives the same simulated answer) after an artificial delay that mimics
/// real network/tool latency. Swapping this for a real backend later means
/// changing what `cyberToolsServiceProvider` resolves to; nothing above
/// [CyberToolsService] needs to change.
class SimulatedCyberToolsService implements CyberToolsService {
  const SimulatedCyberToolsService();

  static const _latency = Duration(milliseconds: 600);

  static const _countries = [
    'France',
    'Germany',
    'United States',
    'Netherlands',
    'Singapore',
    'Brazil',
  ];
  static const _isps = [
    'Orange S.A.',
    'OVH SAS',
    'DigitalOcean LLC',
    'Cloudflare Inc.',
    'Amazon Technologies Inc.',
    'Hetzner Online GmbH',
  ];
  static const _urlCategories = [
    'Technology',
    'News',
    'E-commerce',
    'Social Media',
    'Suspicious',
    'Unknown',
  ];
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

  Random _rngFor(String seed) => Random(seed.hashCode);

  @override
  Future<IpAnalysisResult> analyzeIp(String ip) async {
    await Future<void>.delayed(_latency);
    final rng = _rngFor(ip);
    final riskScore = rng.nextInt(100);
    return IpAnalysisResult(
      ip: ip,
      country: _countries[rng.nextInt(_countries.length)],
      isp: _isps[rng.nextInt(_isps.length)],
      riskScore: riskScore,
      isSuspicious: riskScore > 70,
    );
  }

  @override
  Future<UrlAnalysisResult> analyzeUrl(String url) async {
    await Future<void>.delayed(_latency);
    final rng = _rngFor(url);
    final riskScore = rng.nextInt(100);
    return UrlAnalysisResult(
      url: url,
      category: _urlCategories[rng.nextInt(_urlCategories.length)],
      riskScore: riskScore,
      isSafe: riskScore < 60,
    );
  }

  @override
  Future<PortScanResult> scanPorts(String host, List<int> ports) async {
    await Future<void>.delayed(_latency);
    final rng = _rngFor(host);
    final entries = ports
        .map(
          (port) => PortScanEntry(
            port: port,
            isOpen: rng.nextDouble() < 0.35,
            service: _commonPorts[port] ?? 'Unknown',
          ),
        )
        .toList();
    return PortScanResult(host: host, entries: entries);
  }

  @override
  Future<String> runCommand(String command) async {
    await Future<void>.delayed(_latency);
    final trimmed = command.trim();
    final firstWord = trimmed.split(' ').first.toLowerCase();
    final rest = trimmed.substring(firstWord.length).trim();

    return switch (firstWord) {
      '' => '',
      'help' =>
        'Available commands: help, whoami, ping <host>, ipconfig, netstat, '
            'echo <text>, clear',
      'whoami' => 'aetherdesk-user',
      'ping' => _simulatePing(rest.isEmpty ? 'localhost' : rest),
      'ipconfig' || 'ifconfig' =>
        'eth0: inet 192.168.1.${_rngFor(trimmed).nextInt(254) + 1} '
            'netmask 255.255.255.0',
      'netstat' =>
        'Proto  Local Address       State\n'
            'tcp    0.0.0.0:443         LISTENING\n'
            'tcp    0.0.0.0:8080        LISTENING',
      'echo' => rest,
      'clear' => '',
      _ => "Command not found: '$firstWord'. Type 'help' for a list.",
    };
  }

  String _simulatePing(String host) {
    final rng = _rngFor(host);
    final ms = 8 + rng.nextInt(60);
    return 'Pinging $host: bytes=32 time=${ms}ms TTL=57\n'
        'Reply from $host received in ${ms}ms.';
  }
}
