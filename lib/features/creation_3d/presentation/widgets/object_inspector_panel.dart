import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/material_preset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object_type.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/vector3.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/scene_object_type_widgets.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/vector3_editor_row.dart';
import 'package:flutter/material.dart';

/// Detail/edit panel for the currently selected [SceneObject3d]: name,
/// transform, simulated material and type-specific properties (light
/// intensity, camera field of view).
class ObjectInspectorPanel extends StatelessWidget {
  const ObjectInspectorPanel({
    required this.object,
    required this.onNameChanged,
    required this.onPositionChanged,
    required this.onRotationChanged,
    required this.onScaleChanged,
    required this.onMaterialChanged,
    required this.onLightIntensityChanged,
    required this.onCameraFovChanged,
    super.key,
  });

  final SceneObject3d object;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<Vector3> onPositionChanged;
  final ValueChanged<Vector3> onRotationChanged;
  final ValueChanged<Vector3> onScaleChanged;
  final ValueChanged<MaterialPreset> onMaterialChanged;
  final ValueChanged<double> onLightIntensityChanged;
  final ValueChanged<double> onCameraFovChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(object.type.icon),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                object.type.label(l10n),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          TextFormField(
            key: ValueKey('name-${object.id}'),
            initialValue: object.name,
            decoration: InputDecoration(
              labelText: l10n.creation3dObjectNameLabel,
              border: const OutlineInputBorder(),
            ),
            onFieldSubmitted: onNameChanged,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Vector3EditorRow(
            label: l10n.creation3dPositionLabel,
            value: object.position,
            onChanged: onPositionChanged,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Vector3EditorRow(
            label: l10n.creation3dRotationLabel,
            value: object.rotation,
            onChanged: onRotationChanged,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Vector3EditorRow(
            label: l10n.creation3dScaleLabel,
            value: object.scale,
            onChanged: onScaleChanged,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          DropdownButtonFormField<MaterialPreset>(
            initialValue: object.material,
            decoration: InputDecoration(
              labelText: l10n.creation3dMaterialLabel,
              border: const OutlineInputBorder(),
            ),
            items: MaterialPreset.values
                .map(
                  (preset) => DropdownMenuItem(
                    value: preset,
                    child: Text(preset.label(l10n)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onMaterialChanged(value);
            },
          ),
          if (object.type == SceneObjectType.light) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              l10n.creation3dLightIntensityLabel,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Slider(
              value: object.lightIntensity ?? 1,
              max: 5,
              onChanged: onLightIntensityChanged,
            ),
          ],
          if (object.type == SceneObjectType.camera) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              l10n.creation3dCameraFovLabel,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Slider(
              value: object.cameraFov ?? 50,
              min: 10,
              max: 120,
              onChanged: onCameraFovChanged,
            ),
          ],
        ],
      ),
    );
  }
}
