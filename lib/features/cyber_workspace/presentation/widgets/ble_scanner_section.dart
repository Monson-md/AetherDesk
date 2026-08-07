import 'dart:async';

import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Real Bluetooth Low Energy device scanner via `flutter_blue_plus` — a
/// genuine radio scan, not a simulated device list.
class BleScannerSection extends StatefulWidget {
  const BleScannerSection({super.key});

  @override
  State<BleScannerSection> createState() => _BleScannerSectionState();
}

class _BleScannerSectionState extends State<BleScannerSection> {
  StreamSubscription<List<ScanResult>>? _resultsSub;
  StreamSubscription<bool>? _isScanningSub;
  List<ScanResult> _results = const [];
  bool _isScanning = false;
  bool _isSupported = true;

  @override
  void initState() {
    super.initState();
    _isScanningSub = FlutterBluePlus.isScanning.listen(
      (scanning) => setState(() => _isScanning = scanning),
    );
    _resultsSub = FlutterBluePlus.scanResults.listen(
      (results) => setState(() => _results = results),
    );
  }

  @override
  void dispose() {
    _resultsSub?.cancel();
    _isScanningSub?.cancel();
    super.dispose();
  }

  Future<void> _startScan() async {
    final supported = await FlutterBluePlus.isSupported;
    if (!supported) {
      setState(() => _isSupported = false);
      return;
    }
    setState(() => _results = const []);
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  }

  Future<void> _stopScan() => FlutterBluePlus.stopScan();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bluetooth_searching_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceBleScannerTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (!_isSupported)
              Text(
                l10n.cyberWorkspaceBleUnsupportedMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              )
            else
              OutlinedButton.icon(
                onPressed: _isScanning ? _stopScan : _startScan,
                icon: Icon(
                  _isScanning
                      ? Icons.stop_circle_outlined
                      : Icons.bluetooth_searching_outlined,
                ),
                label: Text(
                  _isScanning
                      ? l10n.cyberWorkspaceBleStopScanButton
                      : l10n.cyberWorkspaceBleStartScanButton,
                ),
              ),
            const SizedBox(height: AppDimensions.spacingSm),
            if (_results.isEmpty)
              Text(
                l10n.cyberWorkspaceBleNoDevicesMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              Column(
                children: _results.map((result) {
                  final name = result.advertisementData.advName.isEmpty
                      ? l10n.cyberWorkspaceBleUnknownDeviceLabel
                      : result.advertisementData.advName;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.bluetooth_outlined),
                    title: Text(name),
                    subtitle: Text(result.device.remoteId.str),
                    trailing: Text('${result.rssi} dBm'),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
