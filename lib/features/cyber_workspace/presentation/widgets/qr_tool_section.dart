import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Real QR/barcode scanning (device camera via `mobile_scanner`) and real
/// QR code generation (`qr_flutter`, pure Dart, no native code).
class QrToolSection extends StatefulWidget {
  const QrToolSection({super.key});

  @override
  State<QrToolSection> createState() => _QrToolSectionState();
}

class _QrToolSectionState extends State<QrToolSection> {
  bool _isScanning = false;
  String? _scannedValue;
  final _generateController = TextEditingController();
  String _dataToEncode = '';

  @override
  void dispose() {
    _generateController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final value = capture.barcodes.isEmpty
        ? null
        : capture.barcodes.first.rawValue;
    if (value == null) return;
    setState(() {
      _scannedValue = value;
      _isScanning = false;
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
                Icon(
                  Icons.qr_code_scanner_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceQrToolTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              l10n.cyberWorkspaceQrScanLabel,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            if (_isScanning)
              SizedBox(
                height: 260,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  child: MobileScanner(onDetect: _onDetect),
                ),
              )
            else
              OutlinedButton.icon(
                onPressed: () => setState(() => _isScanning = true),
                icon: const Icon(Icons.camera_alt_outlined),
                label: Text(l10n.cyberWorkspaceQrStartScanButton),
              ),
            if (_isScanning) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              OutlinedButton(
                onPressed: () => setState(() => _isScanning = false),
                child: Text(l10n.commonCancel),
              ),
            ],
            if (_scannedValue != null) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              SelectableText(
                l10n.cyberWorkspaceQrScannedValueLabel(_scannedValue!),
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const Divider(height: AppDimensions.spacingLg * 2),
            Text(
              l10n.cyberWorkspaceQrGenerateLabel,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            TextField(
              controller: _generateController,
              decoration: InputDecoration(
                labelText: l10n.cyberWorkspaceQrTextToEncodeLabel,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _dataToEncode = value),
            ),
            if (_dataToEncode.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              Center(
                child: QrImageView(
                  data: _dataToEncode,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
