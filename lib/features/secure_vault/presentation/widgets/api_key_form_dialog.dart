import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_folder_widgets.dart';
import 'package:flutter/material.dart';

class ApiKeyFormResult {
  const ApiKeyFormResult({
    required this.title,
    required this.service,
    required this.apiKey,
    required this.folderId,
  });

  final String title;
  final String service;
  final String apiKey;
  final String? folderId;
}

/// Create/edit form for an [ApiKeyItem]. Pass [item] to pre-fill it for
/// editing; omit it to create a new one.
class ApiKeyFormDialog extends StatefulWidget {
  const ApiKeyFormDialog({
    required this.folders,
    required this.onCreateFolder,
    this.item,
    super.key,
  });

  final ApiKeyItem? item;
  final List<VaultFolder> folders;
  final Future<VaultFolder?> Function(String name, int colorValue)
  onCreateFolder;

  @override
  State<ApiKeyFormDialog> createState() => _ApiKeyFormDialogState();
}

class _ApiKeyFormDialogState extends State<ApiKeyFormDialog> {
  late final _titleController = TextEditingController(text: widget.item?.title);
  late final _serviceController = TextEditingController(
    text: widget.item?.service,
  );
  late final _apiKeyController = TextEditingController(
    text: widget.item?.apiKey,
  );
  late List<VaultFolder> _folders = widget.folders;
  late String? _folderId = widget.item?.folderId;
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_handleChanged);
    _apiKeyController.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _serviceController.dispose();
    _apiKeyController.dispose();
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
            ? l10n.secureVaultEditApiKeyTitle
            : l10n.secureVaultNewApiKeyTitle,
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
              label: l10n.secureVaultServiceLabel,
              controller: _serviceController,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextField(
              controller: _apiKeyController,
              obscureText: _obscureKey,
              decoration: InputDecoration(
                labelText: l10n.secureVaultApiKeyLabel,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureKey
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscureKey = !_obscureKey),
                ),
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
                  _apiKeyController.text.isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  ApiKeyFormResult(
                    title: _titleController.text.trim(),
                    service: _serviceController.text.trim(),
                    apiKey: _apiKeyController.text,
                    folderId: _folderId,
                  ),
                ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
