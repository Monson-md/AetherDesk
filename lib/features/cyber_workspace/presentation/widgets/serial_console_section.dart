import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';

/// Real USB-serial console for an external microcontroller (Arduino,
/// ESP32...) connected over an actual USB-OTG cable via `usb_serial` — a
/// genuine UART link, not a simulated device. Typed lines are written
/// verbatim to the wire, so this also serves as a GPIO control panel or an
/// environmental-sensor dashboard for any firmware that speaks line-based
/// text over serial (e.g. sending `LED_ON` or reading back `TEMP:21.4`).
class SerialConsoleSection extends StatefulWidget {
  const SerialConsoleSection({super.key});

  @override
  State<SerialConsoleSection> createState() => _SerialConsoleSectionState();
}

class _SerialConsoleSectionState extends State<SerialConsoleSection> {
  List<UsbDevice> _devices = const [];
  UsbPort? _port;
  StreamSubscription<Uint8List>? _inputSub;
  final List<String> _lines = [];
  final _commandController = TextEditingController();
  bool _isConnected = false;
  String? _errorMessage;

  @override
  void dispose() {
    _inputSub?.cancel();
    _port?.close();
    _commandController.dispose();
    super.dispose();
  }

  Future<void> _refreshDevices() async {
    final devices = await UsbSerial.listDevices();
    setState(() => _devices = devices);
  }

  Future<void> _connect(UsbDevice device) async {
    setState(() => _errorMessage = null);
    final port = await device.create();
    if (port == null) {
      setState(
        () => _errorMessage = AppLocalizations.of(
          context,
        )!.cyberWorkspaceSerialConnectFailedMessage,
      );
      return;
    }
    final opened = await port.open();
    if (!opened) {
      setState(
        () => _errorMessage = AppLocalizations.of(
          context,
        )!.cyberWorkspaceSerialConnectFailedMessage,
      );
      return;
    }
    await port.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );
    _port = port;
    _inputSub = port.inputStream?.listen((data) {
      final text = utf8.decode(data, allowMalformed: true);
      setState(() => _lines.add(text));
    });
    setState(() => _isConnected = true);
  }

  Future<void> _disconnect() async {
    await _inputSub?.cancel();
    _inputSub = null;
    await _port?.close();
    _port = null;
    setState(() => _isConnected = false);
  }

  Future<void> _sendCommand() async {
    final text = _commandController.text;
    if (text.isEmpty || _port == null) return;
    await _port!.write(Uint8List.fromList(utf8.encode('$text\n')));
    setState(() {
      _lines.add('> $text');
      _commandController.clear();
    });
  }

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
                Icon(Icons.usb_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceSerialTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              l10n.cyberWorkspaceSerialSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
                child: Text(
                  _errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            if (!_isConnected) ...[
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: [
                  OutlinedButton.icon(
                    onPressed: _refreshDevices,
                    icon: const Icon(Icons.refresh_outlined),
                    label: Text(l10n.cyberWorkspaceSerialRefreshButton),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              if (_devices.isEmpty)
                Text(
                  l10n.cyberWorkspaceSerialNoDevicesMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                Column(
                  children: _devices.map((device) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.developer_board_outlined),
                      title: Text(device.productName ?? device.deviceName),
                      subtitle: Text(
                        'VID:${device.vid?.toRadixString(16)} '
                        'PID:${device.pid?.toRadixString(16)}',
                      ),
                      trailing: FilledButton(
                        onPressed: () => _connect(device),
                        child: Text(l10n.cyberWorkspaceSerialConnectButton),
                      ),
                    );
                  }).toList(),
                ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.cyberWorkspaceSerialConnectedMessage,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _disconnect,
                    child: Text(l10n.cyberWorkspaceSerialDisconnectButton),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spacingSm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  child: SelectableText(
                    _lines.join(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commandController,
                      decoration: InputDecoration(
                        hintText: l10n.cyberWorkspaceSerialCommandHint,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _sendCommand(),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  IconButton(
                    onPressed: _sendCommand,
                    icon: const Icon(Icons.send_outlined),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
