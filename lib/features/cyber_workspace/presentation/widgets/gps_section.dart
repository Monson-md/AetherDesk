import 'dart:async';

import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Real device GPS dashboard via `geolocator` — an actual location fix from
/// the phone's own GPS/fused location provider, not a simulated coordinate
/// or a paid IP-geolocation API.
class GpsSection extends StatefulWidget {
  const GpsSection({super.key});

  @override
  State<GpsSection> createState() => _GpsSectionState();
}

class _GpsSectionState extends State<GpsSection> {
  StreamSubscription<Position>? _positionSub;
  Position? _position;
  bool _isTracking = false;
  String? _errorMessage;

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  Future<void> _startTracking() async {
    setState(() => _errorMessage = null);

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(
        () => _errorMessage = AppLocalizations.of(
          context,
        )!.cyberWorkspaceGpsServiceDisabledMessage,
      );
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(
        () => _errorMessage = AppLocalizations.of(
          context,
        )!.cyberWorkspaceGpsPermissionDeniedMessage,
      );
      return;
    }

    setState(() => _isTracking = true);
    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(distanceFilter: 1),
        ).listen(
          (position) => setState(() => _position = position),
          onError: (Object error) {
            if (!mounted) return;
            setState(() {
              _errorMessage = '$error';
              _isTracking = false;
            });
          },
        );
  }

  Future<void> _stopTracking() async {
    await _positionSub?.cancel();
    _positionSub = null;
    setState(() => _isTracking = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final position = _position;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.gps_fixed_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceGpsTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ],
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
              onPressed: _isTracking ? _stopTracking : _startTracking,
              icon: Icon(
                _isTracking
                    ? Icons.stop_circle_outlined
                    : Icons.gps_fixed_outlined,
              ),
              label: Text(
                _isTracking
                    ? l10n.cyberWorkspaceGpsStopButton
                    : l10n.cyberWorkspaceGpsStartButton,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            if (position == null)
              Text(
                l10n.cyberWorkspaceGpsNoFixMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GpsRow(
                    label: l10n.cyberWorkspaceGpsLatitudeLabel,
                    value: position.latitude.toStringAsFixed(6),
                  ),
                  _GpsRow(
                    label: l10n.cyberWorkspaceGpsLongitudeLabel,
                    value: position.longitude.toStringAsFixed(6),
                  ),
                  _GpsRow(
                    label: l10n.cyberWorkspaceGpsAccuracyLabel,
                    value: '${position.accuracy.toStringAsFixed(1)} m',
                  ),
                  _GpsRow(
                    label: l10n.cyberWorkspaceGpsAltitudeLabel,
                    value: '${position.altitude.toStringAsFixed(1)} m',
                  ),
                  _GpsRow(
                    label: l10n.cyberWorkspaceGpsSpeedLabel,
                    value: '${position.speed.toStringAsFixed(1)} m/s',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _GpsRow extends StatelessWidget {
  const _GpsRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
