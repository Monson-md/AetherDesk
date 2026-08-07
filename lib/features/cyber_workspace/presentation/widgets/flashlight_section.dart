import 'dart:async';

import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

/// Real flashlight control (steady on/off and a strobe mode) via
/// `torch_light` — actually toggles the device's hardware torch.
class FlashlightSection extends StatefulWidget {
  const FlashlightSection({super.key});

  @override
  State<FlashlightSection> createState() => _FlashlightSectionState();
}

class _FlashlightSectionState extends State<FlashlightSection> {
  bool _isOn = false;
  bool _isStrobing = false;
  bool _isAvailable = true;
  Timer? _strobeTimer;

  @override
  void dispose() {
    _strobeTimer?.cancel();
    if (_isOn) {
      unawaited(TorchLight.disableTorch());
    }
    super.dispose();
  }

  Future<void> _toggleTorch() async {
    try {
      if (_isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() => _isOn = !_isOn);
    } on Exception {
      setState(() => _isAvailable = false);
    }
  }

  Future<void> _toggleStrobe() async {
    if (_isStrobing) {
      _strobeTimer?.cancel();
      _strobeTimer = null;
      try {
        await TorchLight.disableTorch();
      } on Exception {
        // Ignore — best-effort cleanup.
      }
      setState(() {
        _isStrobing = false;
        _isOn = false;
      });
      return;
    }
    setState(() => _isStrobing = true);
    var on = false;
    _strobeTimer = Timer.periodic(const Duration(milliseconds: 150), (
      timer,
    ) async {
      on = !on;
      try {
        if (on) {
          await TorchLight.enableTorch();
        } else {
          await TorchLight.disableTorch();
        }
      } on Exception {
        timer.cancel();
        if (mounted) setState(() => _isStrobing = false);
      }
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
                  Icons.flashlight_on_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceFlashlightTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (!_isAvailable)
              Text(
                l10n.cyberWorkspaceFlashlightUnavailableMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              )
            else
              Wrap(
                spacing: AppDimensions.spacingSm,
                children: [
                  FilledButton.icon(
                    onPressed: _isStrobing ? null : _toggleTorch,
                    icon: Icon(
                      _isOn
                          ? Icons.flashlight_off_outlined
                          : Icons.flashlight_on_outlined,
                    ),
                    label: Text(
                      _isOn
                          ? l10n.cyberWorkspaceFlashlightOffButton
                          : l10n.cyberWorkspaceFlashlightOnButton,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _toggleStrobe,
                    icon: const Icon(Icons.bolt_outlined),
                    label: Text(
                      _isStrobing
                          ? l10n.cyberWorkspaceFlashlightStopStrobeButton
                          : l10n.cyberWorkspaceFlashlightStrobeButton,
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
