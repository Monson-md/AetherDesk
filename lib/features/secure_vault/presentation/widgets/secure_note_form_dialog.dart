import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_folder_widgets.dart';
import 'package:flutter/material.dart';

class SecureNoteFormResult {
  const SecureNoteFormResult({
    required this.title,
    required this.content,
    required this.folderId,
  });

  final String title;
  final String content;
  final String? folderId;
}

/// Create/edit form for a [SecureNoteItem]. Pass [item] to pre-fill it for
/// editing; omit it to create a new one.
class SecureNoteFormDialog extends StatefulWidget {
  const SecureNoteFormDialog({
    required this.folders,
    required this.onCreateFolder,
    this.item,
    super.key,
  });

  final SecureNoteItem? item;
  final List<VaultFolder> folders;
  final Future<VaultFolder?> Function(String name, int colorValue)
  onCreateFolder;

  @override
  State<SecureNoteFormDialog> createState() => _SecureNoteFormDialogState();
}

class _SecureNoteFormDialogState extends State<SecureNoteFormDialog> {
  late final _titleController = TextEditingController(text: widget.item?.title);
  late final _contentController = TextEditingController(
    text: widget.item?.content,
  );
  late List<VaultFolder> _folders = widget.folders;
  late String? _folderId = widget.item?.folderId;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleChanged() => setState(() {});

  Future<void> _createFolder() async {
    final created = await showDialog<VaultFolder>(
      context: context,
      builder: (context) => const CreateFolderDialog(),
    );
    if (created == null || !mounted) return;
    final folder = await widget.onCreateFolder(
      created.name,
      created.colorValue,
    );
    if (folder == null || !mounted) return;
    setState(() {
      _folders = [..._folders, folder];
      _folderId = folder.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.item != null;

    return AlertDialog(
      title: Text(
        isEditing
            ? l10n.secureVaultEditSecureNoteTitle
            : l10n.secureVaultNewSecureNoteTitle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: l10n.secureVaultTitleLabel,
              controller: _titleController,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: l10n.secureVaultContentLabel,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            FolderPickerField(
              folders: _folders,
              value: _folderId,
              onChanged: (value) => setState(() => _folderId = value),
              onCreateFolder: _createFolder,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _titleController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  SecureNoteFormResult(
                    title: _titleController.text.trim(),
                    content: _contentController.text.trim(),
                    folderId: _folderId,
                  ),
                ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
