import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';

/// Real NFC tag/badge reader via `nfc_manager` — reads the actual UID and
/// tech list broadcast by a physical NFC tag or contactless badge using the
/// phone's own NFC radio. Read-only: this is an auditing tool (e.g.
/// confirming which UID a badge presents), not a cloning or access-bypass
/// tool.
class NfcSection extends StatefulWidget {
  const NfcSection({super.key});

  @override
  State<NfcSection> createState() => _NfcSectionState();
}

class _NfcSectionState extends State<NfcSection> {
  bool _isScanning = false;
  String? _uidHex;
  List<String> _techList = const [];
  String? _errorMessage;

  Future<void> _startScan() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _errorMessage = null;
      _uidHex = null;
      _techList = const [];
    });

    final availability = await NfcManager.instance.checkAvailability();
    if (availability != NfcAvailability.enabled) {
      setState(() => _errorMessage = l10n.cyberWorkspaceNfcUnavailableMessage);
      return;
    }

    setState(() => _isScanning = true);
    await NfcManager.instance.startSession(
      pollingOptions: NfcPollingOption.values.toSet(),
      onDiscovered: (tag) async {
        final androidTag = NfcTagAndroid.from(tag);
        if (androidTag != null) {
          final uid = androidTag.id
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join(':')
              .toUpperCase();
          if (mounted) {
            setState(() {
              _uidHex = uid;
              _techList = androidTag.techList;
            });
          }
        }
        await NfcManager.instance.stopSession();
        if (mounted) setState(() => _isScanning = false);
      },
    );
  }

  Future<void> _stopScan() async {
    await NfcManager.instance.stopSession();
    setState(() => _isScanning = false);
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
                Icon(Icons.nfc_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceNfcTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              l10n.cyberWorkspaceNfcSubtitle,
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
            OutlinedButton.icon(
              onPressed: _isScanning ? _stopScan : _startScan,
              icon: Icon(
                _isScanning ? Icons.stop_circle_outlined : Icons.nfc_outlined,
              ),
              label: Text(
                _isScanning
                    ? l10n.cyberWorkspaceNfcStopButton
                    : l10n.cyberWorkspaceNfcScanButton,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            if (_uidHex == null)
              Text(
                l10n.cyberWorkspaceNfcNoTagMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    l10n.cyberWorkspaceNfcUidLabel(_uidHex!),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    l10n.cyberWorkspaceNfcTechListLabel(_techList.join(', ')),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
