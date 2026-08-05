import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object.dart';
import 'package:aetherdesk/features/creation_3d/presentation/widgets/scene_object_type_widgets.dart';
import 'package:flutter/material.dart';

/// List of every [SceneObject3d] in the scene, with visibility/lock toggles
/// and a per-object menu for duplicate/delete.
class SceneOutliner extends StatelessWidget {
  const SceneOutliner({
    required this.objects,
    required this.selectedObjectId,
    required this.onSelected,
    required this.onVisibilityChanged,
    required this.onLockChanged,
    required this.onDuplicate,
    required this.onDelete,
    super.key,
  });

  final List<SceneObject3d> objects;
  final String? selectedObjectId;
  final ValueChanged<String> onSelected;
  final void Function(String objectId, bool isVisible) onVisibilityChanged;
  final void Function(String objectId, bool isLocked) onLockChanged;
  final ValueChanged<String> onDuplicate;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView.builder(
      itemCount: objects.length,
      itemBuilder: (context, index) {
        final object = objects[index];
        final isSelected = object.id == selectedObjectId;
        return ListTile(
          selected: isSelected,
          selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
          leading: Icon(object.type.icon),
          title: Text(object.name, overflow: TextOverflow.ellipsis),
          onTap: () => onSelected(object.id),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  object.isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                ),
                onPressed: () =>
                    onVisibilityChanged(object.id, !object.isVisible),
              ),
              IconButton(
                icon: Icon(
                  object.isLocked
                      ? Icons.lock_outline
                      : Icons.lock_open_outlined,
                  size: 20,
                ),
                onPressed: () => onLockChanged(object.id, !object.isLocked),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (value) {
                  if (value == 'duplicate') {
                    onDuplicate(object.id);
                  } else if (value == 'delete') {
                    onDelete(object.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Text(l10n.creation3dDuplicateObject),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(l10n.commonDelete),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
