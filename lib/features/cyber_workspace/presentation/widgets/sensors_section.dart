import 'dart:async';

import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Real-time accelerometer/gyroscope/magnetometer readings from the
/// device's actual hardware sensors via `sensors_plus` — no simulated
/// values.
class SensorsSection extends StatefulWidget {
  const SensorsSection({super.key});

  @override
  State<SensorsSection> createState() => _SensorsSectionState();
}

class _SensorsSectionState extends State<SensorsSection> {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  StreamSubscription<MagnetometerEvent>? _magnetSub;

  AccelerometerEvent? _accel;
  GyroscopeEvent? _gyro;
  MagnetometerEvent? _magnet;

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEventStream().listen(
      (event) => setState(() => _accel = event),
    );
    _gyroSub = gyroscopeEventStream().listen(
      (event) => setState(() => _gyro = event),
    );
    _magnetSub = magnetometerEventStream().listen(
      (event) => setState(() => _magnet = event),
    );
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _magnetSub?.cancel();
    super.dispose();
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
                Icon(Icons.sensors_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceSensorsTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            _SensorRow(
              label: l10n.cyberWorkspaceAccelerometerLabel,
              event3: _accel,
            ),
            _SensorRow(label: l10n.cyberWorkspaceGyroscopeLabel, event3: _gyro),
            _SensorRow(
              label: l10n.cyberWorkspaceMagnetometerLabel,
              event3: _magnet,
            ),
          ],
        ),
      ),
    );
  }
}

class _SensorRow extends StatelessWidget {
  const _SensorRow({required this.label, required this.event3});

  final String label;
  final Object? event3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String values = '—';
    final event = event3;
    if (event is AccelerometerEvent) {
      values =
          'x: ${event.x.toStringAsFixed(2)}  y: ${event.y.toStringAsFixed(2)}  z: ${event.z.toStringAsFixed(2)}';
    } else if (event is GyroscopeEvent) {
      values =
          'x: ${event.x.toStringAsFixed(2)}  y: ${event.y.toStringAsFixed(2)}  z: ${event.z.toStringAsFixed(2)}';
    } else if (event is MagnetometerEvent) {
      values =
          'x: ${event.x.toStringAsFixed(2)}  y: ${event.y.toStringAsFixed(2)}  z: ${event.z.toStringAsFixed(2)}';
    }
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
              values,
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
