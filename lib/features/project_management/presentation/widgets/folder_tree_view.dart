import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_folder.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/folder_form_dialog.dart';
import 'package:flutter/material.dart';

/// Drawer content listing the project folder tree: an "all projects" root
/// entry, then every [ProjectFolder] indented under its parent, each with
/// inline actions to add a subfolder, rename or delete it.
class FolderTreeView extends StatelessWidget {
  const FolderTreeView({
    required this.folders,
    required this.selectedFolderId,
    required this.onSelectFolder,
    required this.onCreateFolder,
    required this.onRenameFolder,
    required this.onDeleteFolder,
    super.key,
  });

  final List<ProjectFolder> folders;
  final String? selectedFolderId;
  final ValueChanged<String?> onSelectFolder;
  final void Function(String? parentId) onCreateFolder;
  final void Function(ProjectFolder folder) onRenameFolder;
  final void Function(ProjectFolder folder) onDeleteFolder;

  List<ProjectFolder> _childrenOf(String? parentId) =>
      folders.where((folder) => folder.parentId == parentId).toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spacingMd,
              AppDimensions.spacingLg,
              AppDimensions.spacingMd,
              AppDimensions.spacingSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.projectManagementFoldersTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.create_new_folder_outlined),
                  tooltip: l10n.projectManagementNewFolderTitle,
                  onPressed: () => onCreateFolder(null),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.all_inbox_outlined),
            title: Text(l10n.projectManagementAllProjects),
            selected: selectedFolderId == null,
            onTap: () => onSelectFolder(null),
          ),
          Expanded(child: ListView(children: _buildLevel(context, null, 0))),
        ],
      ),
    );
  }

  List<Widget> _buildLevel(BuildContext context, String? parentId, int depth) {
    final l10n = AppLocalizations.of(context)!;
    final widgets = <Widget>[];
    for (final folder in _childrenOf(parentId)) {
      widgets.add(
        ListTile(
          contentPadding: EdgeInsets.only(
            left: AppDimensions.spacingMd + depth * AppDimensions.spacingLg,
            right: AppDimensions.spacingXs,
          ),
          leading: const Icon(Icons.folder_outlined),
          title: Text(folder.name, overflow: TextOverflow.ellipsis),
          selected: selectedFolderId == folder.id,
          onTap: () => onSelectFolder(folder.id),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 20),
            onSelected: (action) => _handleAction(context, action, folder),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'subfolder',
                child: Text(l10n.projectManagementNewSubfolder),
              ),
              PopupMenuItem(
                value: 'rename',
                child: Text(l10n.projectManagementRenameFolderTitle),
              ),
              PopupMenuItem(value: 'delete', child: Text(l10n.commonDelete)),
            ],
          ),
        ),
      );
      widgets.addAll(_buildLevel(context, folder.id, depth + 1));
    }
    return widgets;
  }

  Future<void> _handleAction(
    BuildContext context,
    String action,
    ProjectFolder folder,
  ) async {
    switch (action) {
      case 'subfolder':
        onCreateFolder(folder.id);
      case 'rename':
        final name = await showDialog<String>(
          context: context,
          builder: (context) => FolderFormDialog(initialName: folder.name),
        );
        if (name != null) onRenameFolder(folder.withName(name));
      case 'delete':
        final l10n = AppLocalizations.of(context)!;
        final confirmed = await AppAlertDialog.show(
          context,
          title: l10n.projectManagementDeleteFolderTitle,
          message: l10n.projectManagementDeleteFolderMessage,
          confirmLabel: l10n.commonConfirm,
          cancelLabel: l10n.commonCancel,
        );
        if (confirmed) onDeleteFolder(folder);
    }
  }
}
