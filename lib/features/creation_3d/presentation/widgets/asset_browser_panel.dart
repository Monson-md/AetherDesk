import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_asset.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/scene_object_type_widgets.dart';
import 'package:flutter/material.dart';

/// Catalog of prefab objects that can be added to the scene — a compact
/// horizontal strip of chips so it fits above the scene outliner.
class AssetBrowserPanel extends StatelessWidget {
  const AssetBrowserPanel({
    required this.assets,
    required this.onAssetSelected,
    super.key,
  });

  final List<SceneAsset> assets;
  final ValueChanged<SceneAsset> onAssetSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.creation3dAssetsTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: assets.map((asset) {
            return ActionChip(
              avatar: Icon(asset.type.icon, size: 18),
              label: Text(asset.name),
              onPressed: () => onAssetSelected(asset),
            );
          }).toList(),
        ),
      ],
    );
  }
}
