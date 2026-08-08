import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_asset.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/scene_object_type_widgets.dart';
import 'package:flutter/material.dart';

/// Landscape counterpart to [AssetBrowserPanel]: the same asset catalog and
/// [onAssetSelected] action, laid out as a narrow vertical icon rail so it
/// fits alongside the viewport and transform panel instead of taking a full
/// column above the outliner.
class ObjectPaletteRail extends StatelessWidget {
  const ObjectPaletteRail({
    required this.assets,
    required this.onAssetSelected,
    super.key,
  });

  final List<SceneAsset> assets;
  final ValueChanged<SceneAsset> onAssetSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                Icons.add_box_outlined,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              for (final asset in assets)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spacingXs,
                  ),
                  child: Tooltip(
                    message: '${asset.name} · ${asset.type.label(l10n)}',
                    child: IconButton(
                      icon: Icon(asset.type.icon),
                      onPressed: () => onAssetSelected(asset),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
