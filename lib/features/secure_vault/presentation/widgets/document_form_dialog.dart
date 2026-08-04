import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_folder_widgets.dart';
import 'package:flutter/material.dart';

class DocumentFormResult {
  const DocumentFormResult({
    required this.title,
    required this.fileName,
    required this.notes,
    required this.folderId,
  });

  final String title;
  final String fileName;
  final String? notes;
  final String? folderId;
}

/// Create/edit form for a [DocumentItem]. Pass [item] to pre-fill it for
/// editing; omit it to create a new one. No real file is attached or read
/// from disk — [fileName] is a plain display label the user types in.
class DocumentFormDialog extends StatefulWidget {
  const DocumentFormDialog({
    required this.folders,
    required this.onCreateFolder,
    this.item,
    super.key,
  });

  final DocumentItem? item;
  final List<VaultFolder> folders;
  final Future<VaultFolder?> Function(String name, int colorValue)
  onCreateFolder;

  @override
  State<DocumentFormDialog> createState() => _DocumentFormDialogState();
}

class _DocumentFormDialogState extends State<DocumentFormDialog> {
  late final _titleController = TextEditingController(text: widget.item?.title);
  late final _fileNameController = TextEditingController(
    text: widget.item?.fileName,
  );
  late final _notesController = TextEditingController(text: widget.item?.notes);
  late List<VaultFolder> _folders = widget.folders;
  late String? _folderId = widget.item?.folderId;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_handleChanged);
    _fileNameController.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fileNameController.dispose();
    _notesController.dispose();
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
            ? l10n.secureVaultEditDocumentTitle
            : l10n.secureVaultNewDocumentTitle,
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
            AppTextField(
              label: l10n.secureVaultFileNameLabel,
              controller: _fileNameController,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.secureVaultNotesLabel,
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
          onPressed:
              _titleController.text.trim().isEmpty ||
                  _fileNameController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  DocumentFormResult(
                    title: _titleController.text.trim(),
                    fileName: _fileNameController.text.trim(),
                    notes: _notesController.text.trim().isEmpty
                        ? null
                        : _notesController.text.trim(),
                    folderId: _folderId,
                  ),
                ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
