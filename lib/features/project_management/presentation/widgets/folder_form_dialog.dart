import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:flutter/material.dart';

/// Single-field dialog for naming a new folder or renaming an existing one.
class FolderFormDialog extends StatefulWidget {
  const FolderFormDialog({this.initialName, super.key});

  final String? initialName;

  @override
  State<FolderFormDialog> createState() => _FolderFormDialogState();
}

class _FolderFormDialogState extends State<FolderFormDialog> {
  late final _nameController = TextEditingController(text: widget.initialName);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_handleNameChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleNameChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.initialName != null;

    return AlertDialog(
      title: Text(
        isEditing
            ? l10n.projectManagementRenameFolderTitle
            : l10n.projectManagementNewFolderTitle,
      ),
      content: AppTextField(
        label: l10n.projectManagementFolderNameLabel,
        controller: _nameController,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _nameController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(_nameController.text.trim()),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
