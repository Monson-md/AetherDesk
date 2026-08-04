import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_folder_widgets.dart';
import 'package:flutter/material.dart';

class PasswordFormResult {
  const PasswordFormResult({
    required this.title,
    required this.username,
    required this.password,
    required this.url,
    required this.folderId,
  });

  final String title;
  final String username;
  final String password;
  final String? url;
  final String? folderId;
}

/// Create/edit form for a [PasswordItem]. Pass [item] to pre-fill it for
/// editing; omit it to create a new one.
class PasswordFormDialog extends StatefulWidget {
  const PasswordFormDialog({
    required this.folders,
    required this.onCreateFolder,
    this.item,
    super.key,
  });

  final PasswordItem? item;
  final List<VaultFolder> folders;
  final Future<VaultFolder?> Function(String name, int colorValue)
  onCreateFolder;

  @override
  State<PasswordFormDialog> createState() => _PasswordFormDialogState();
}

class _PasswordFormDialogState extends State<PasswordFormDialog> {
  late final _titleController = TextEditingController(text: widget.item?.title);
  late final _usernameController = TextEditingController(
    text: widget.item?.username,
  );
  late final _passwordController = TextEditingController(
    text: widget.item?.password,
  );
  late final _urlController = TextEditingController(text: widget.item?.url);
  late List<VaultFolder> _folders = widget.folders;
  late String? _folderId = widget.item?.folderId;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_handleChanged);
    _passwordController.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
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
            ? l10n.secureVaultEditPasswordTitle
            : l10n.secureVaultNewPasswordTitle,
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
              label: l10n.secureVaultUsernameLabel,
              controller: _usernameController,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: l10n.secureVaultPasswordLabel,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            AppTextField(
              label: l10n.secureVaultUrlLabel,
              controller: _urlController,
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
                  _passwordController.text.isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  PasswordFormResult(
                    title: _titleController.text.trim(),
                    username: _usernameController.text.trim(),
                    password: _passwordController.text,
                    url: _urlController.text.trim().isEmpty
                        ? null
                        : _urlController.text.trim(),
                    folderId: _folderId,
                  ),
                ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
