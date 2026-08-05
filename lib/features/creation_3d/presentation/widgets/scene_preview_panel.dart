import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object_type.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/scene_object_type_widgets.dart';
import 'package:flutter/material.dart';

/// Real-time top-down schematic of the scene's visible objects (x/z mapped
/// to the panel, size hinting at scale) — not a real 3D render (this app
/// has no 3D engine), but a genuine, live projection of the actual scene
/// data. The export button writes the real scene graph to a JSON file, see
/// `creation_3d_home_page.dart`'s `_exportScene`.
class ScenePreviewPanel extends StatelessWidget {
  const ScenePreviewPanel({
    required this.objects,
    required this.isExporting,
    required this.onExport,
    super.key,
  });

  final List<SceneObject3d> objects;
  final bool isExporting;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visibleObjects = objects.where((object) => object.isVisible).toList();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: visibleObjects.map((object) {
                    final centerX = constraints.maxWidth / 2;
                    final centerY = constraints.maxHeight / 2;
                    const scaleFactor = 18.0;
                    final left = (centerX + object.position.x * scaleFactor)
                        .clamp(0.0, constraints.maxWidth - 32);
                    final top = (centerY - object.position.z * scaleFactor)
                        .clamp(0.0, constraints.maxHeight - 32);
                    final size =
                        (24 *
                                ((object.scale.x +
                                        object.scale.y +
                                        object.scale.z) /
                                    3))
                            .clamp(12.0, 64.0);
                    return Positioned(
                      left: left,
                      top: top,
                      child: Tooltip(
                        message: object.name,
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            color: Color(
                              object.colorValue,
                            ).withValues(alpha: 0.85),
                            shape: object.type == SceneObjectType.sphere
                                ? BoxShape.circle
                                : BoxShape.rectangle,
                            borderRadius: object.type == SceneObjectType.sphere
                                ? null
                                : BorderRadius.circular(4),
                          ),
                          child: Icon(
                            object.type.icon,
                            size: size * 0.6,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Positioned(
            left: AppDimensions.spacingSm,
            top: AppDimensions.spacingSm,
            child: Text(
              l10n.creation3dSchematicPreviewLabel,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.white70),
            ),
          ),
          Positioned(
            right: AppDimensions.spacingSm,
            bottom: AppDimensions.spacingSm,
            child: FilledButton.icon(
              icon: isExporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.ios_share_outlined),
              label: Text(l10n.creation3dExportScene),
              onPressed: isExporting ? null : onExport,
            ),
          ),
        ],
      ),
    );
  }
}
