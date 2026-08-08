import 'dart:async';
import 'dart:io';

import 'package:aetherdesk/core/services/cyber_tools/cyber_tools_service.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';
import 'package:http/http.dart' as http;

/// Real, `dart:io`-backed [CyberToolsService]: genuine DNS lookups, TCP
/// connection attempts, and a couple of small real HTTP calls to public,
/// free, no-auth endpoints (`myip`/`speedtest`) — no fabricated
/// geolocation/ISP/threat data. See [CyberToolsService]'s doc comment for
/// what's intentionally left out and why.
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
        return 'Available commands: help, whoami, ping <host>, dns <host>, '
            'portcheck <host> <port>, myip, speedtest, ifconfig, '
            'echo <text>, clear';
      case 'whoami':
        return Platform.environment['USER'] ??
            Platform.environment['USERNAME'] ??
            Platform.localHostname;
      case 'ping':
        return _ping(rest.isEmpty ? 'localhost' : rest);
      case 'dns':
        return _dns(rest);
      case 'portcheck':
        return _portCheck(rest);
      case 'myip':
        return _myIp();
      case 'speedtest':
        return _speedTest();
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

  Future<String> _dns(String host) async {
    if (host.isEmpty) return 'Usage: dns <host>';
    try {
      final addresses = await InternetAddress.lookup(host);
      if (addresses.isEmpty) return 'No records found for $host.';
      return addresses
          .map((address) => '${address.type.name}\t${address.address}')
          .join('\n');
    } on Exception catch (error) {
      return 'DNS lookup failed for $host: $error';
    }
  }

  Future<String> _portCheck(String args) async {
    final parts = args.split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.length != 2) return 'Usage: portcheck <host> <port>';
    final port = int.tryParse(parts[1]);
    if (port == null) return "Invalid port: '${parts[1]}'";
    final responseTime = await _tryConnect(parts[0], port);
    if (responseTime == null) {
      return '${parts[0]}:$port is closed or unreachable.';
    }
    return '${parts[0]}:$port is open (${responseTime.inMilliseconds}ms).';
  }

  Future<String> _myIp() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.ipify.org'))
          .timeout(_connectTimeout);
      if (response.statusCode != 200) {
        return 'Could not determine public IP (HTTP ${response.statusCode}).';
      }
      return 'Public IP: ${response.body.trim()}';
    } on Exception catch (error) {
      return 'Could not determine public IP: $error';
    }
  }

  Future<String> _speedTest() async {
    const testUrl = 'https://speed.cloudflare.com/__down?bytes=2000000';
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http
          .get(Uri.parse(testUrl))
          .timeout(const Duration(seconds: 15));
      stopwatch.stop();
      if (response.statusCode != 200) {
        return 'Speed test failed (HTTP ${response.statusCode}).';
      }
      final seconds = stopwatch.elapsedMilliseconds / 1000;
      final megabits = (response.bodyBytes.length * 8) / 1000000;
      final mbps = seconds > 0 ? megabits / seconds : 0;
      return 'Downloaded ${response.bodyBytes.length} bytes in '
          '${stopwatch.elapsedMilliseconds}ms (${mbps.toStringAsFixed(2)} Mbps).';
    } on Exception catch (error) {
      return 'Speed test failed: $error';
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
