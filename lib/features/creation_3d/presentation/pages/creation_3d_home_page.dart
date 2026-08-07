import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/services/files/file_io_service_provider.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/creation_3d/presentation/providers/creation_3d_controller.dart';
import 'package:aetherdesk/features/creation_3d/presentation/providers/creation_3d_providers.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/asset_browser_panel.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/object_inspector_panel.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/scene_3d_viewport.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/scene_outliner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `creation_3d` module: a scene graph editor (asset
/// browser, outliner, inspector) plus a real, interactive 3D viewport (see
/// `Scene3dViewport`), backed by an in-memory [Creation3dController].
/// [_exportScene] writes the real scene graph to a real JSON file via
/// `FileIoService`.
class Creation3dHomePage extends ConsumerStatefulWidget {
  const Creation3dHomePage({super.key});

  @override
  ConsumerState<Creation3dHomePage> createState() => _Creation3dHomePageState();
}

class _Creation3dHomePageState extends ConsumerState<Creation3dHomePage> {
  bool _isExporting = false;

  Future<void> _exportScene() async {
    setState(() => _isExporting = true);
    try {
      final json = ref.read(exportSceneUseCaseProvider).call();
      final projectName = ref.read(creation3dControllerProvider).project.name;
      final saved = await ref
          .read(fileIoServiceProvider)
          .saveTextFile(suggestedName: '$projectName.json', content: json);
      if (!mounted || saved == null) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              )!.creation3dSceneExportedMessage(saved.fileName),
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.creation3d);
    final state = ref.watch(creation3dControllerProvider);
    final controller = ref.read(creation3dControllerProvider.notifier);
    final selected = state.selectedObject;

    return Scaffold(
      appBar: AppBar(title: Text(destination.label)),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final outlinerColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssetBrowserPanel(
                  assets: state.assets,
                  onAssetSelected: controller.addObject,
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Expanded(
                  child: SceneOutliner(
                    objects: state.project.objects,
                    selectedObjectId: state.selectedObjectId,
                    onSelected: controller.selectObject,
                    onVisibilityChanged: (id, isVisible) => controller
                        .updateObject(objectId: id, isVisible: isVisible),
                    onLockChanged: (id, isLocked) => controller.updateObject(
                      objectId: id,
                      isLocked: isLocked,
                    ),
                    onDuplicate: controller.duplicateObject,
                    onDelete: controller.deleteObject,
                  ),
                ),
              ],
            );

            final workspaceColumn = Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Scene3dViewport(
                    objects: state.project.objects,
                    selectedObjectId: state.selectedObjectId,
                    onObjectSelected: controller.selectObject,
                    isExporting: _isExporting,
                    onExport: _exportScene,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Expanded(
                  flex: 2,
                  child: selected == null
                      ? EmptyStateWidget(
                          icon: Icons.category_outlined,
                          title: l10n.creation3dNoSelectionTitle,
                          message: l10n.creation3dNoSelectionMessage,
                        )
                      : Card(
                          child: ObjectInspectorPanel(
                            object: selected,
                            onNameChanged: (name) => controller.updateObject(
                              objectId: selected.id,
                              name: name,
                            ),
                            onPositionChanged: (position) =>
                                controller.updateObject(
                                  objectId: selected.id,
                                  position: position,
                                ),
                            onRotationChanged: (rotation) =>
                                controller.updateObject(
                                  objectId: selected.id,
                                  rotation: rotation,
                                ),
                            onScaleChanged: (scale) => controller.updateObject(
                              objectId: selected.id,
                              scale: scale,
                            ),
                            onMaterialChanged: (material) =>
                                controller.updateObject(
                                  objectId: selected.id,
                                  material: material,
                                ),
                            onLightIntensityChanged: (value) =>
                                controller.updateObject(
                                  objectId: selected.id,
                                  lightIntensity: value,
                                ),
                            onCameraFovChanged: (value) =>
                                controller.updateObject(
                                  objectId: selected.id,
                                  cameraFov: value,
                                ),
                          ),
                        ),
                ),
              ],
            );

            if (constraints.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: 280, child: outlinerColumn),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(child: workspaceColumn),
                ],
              );
            }
            return Column(
              children: [
                SizedBox(height: 220, child: outlinerColumn),
                const SizedBox(height: AppDimensions.spacingMd),
                Expanded(child: workspaceColumn),
              ],
            );
          },
        ),
      ),
    );
  }
}
