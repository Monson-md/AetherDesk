import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/material_preset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object_type.dart';
import 'package:flutter/material.dart';

/// Icon/label presentation for [SceneObjectType], kept in `presentation/`
/// since the domain entity itself must stay free of Flutter imports.
extension SceneObjectTypePresentation on SceneObjectType {
  IconData get icon => switch (this) {
    SceneObjectType.cube => Icons.crop_square_outlined,
    SceneObjectType.sphere => Icons.circle_outlined,
    SceneObjectType.cylinder => Icons.crop_portrait_outlined,
    SceneObjectType.cone => Icons.change_history_outlined,
    SceneObjectType.plane => Icons.crop_din_outlined,
    SceneObjectType.light => Icons.lightbulb_outline,
    SceneObjectType.camera => Icons.videocam_outlined,
  };

  String label(AppLocalizations l10n) => switch (this) {
    SceneObjectType.cube => l10n.creation3dTypeCube,
    SceneObjectType.sphere => l10n.creation3dTypeSphere,
    SceneObjectType.cylinder => l10n.creation3dTypeCylinder,
    SceneObjectType.cone => l10n.creation3dTypeCone,
    SceneObjectType.plane => l10n.creation3dTypePlane,
    SceneObjectType.light => l10n.creation3dTypeLight,
    SceneObjectType.camera => l10n.creation3dTypeCamera,
  };
}

/// Label presentation for [MaterialPreset].
extension MaterialPresetPresentation on MaterialPreset {
  String label(AppLocalizations l10n) => switch (this) {
    MaterialPreset.matte => l10n.creation3dMaterialMatte,
    MaterialPreset.metallic => l10n.creation3dMaterialMetallic,
    MaterialPreset.glass => l10n.creation3dMaterialGlass,
    MaterialPreset.emissive => l10n.creation3dMaterialEmissive,
  };
}
