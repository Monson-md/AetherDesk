import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_folder_widgets.dart';
import 'package:flutter/material.dart';

class CardFormResult {
  const CardFormResult({
    required this.title,
    required this.cardholderName,
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
    required this.folderId,
  });

  final String title;
  final String cardholderName;
  final String cardNumber;
  final String expiry;
  final String? cvv;
  final String? folderId;
}

/// Create/edit form for a [CardItem]. Pass [item] to pre-fill it for
/// editing; omit it to create a new one.
class CardFormDialog extends StatefulWidget {
  const CardFormDialog({
    required this.folders,
    required this.onCreateFolder,
    this.item,
    super.key,
  });

  final CardItem? item;
  final List<VaultFolder> folders;
  final Future<VaultFolder?> Function(String name, int colorValue)
  onCreateFolder;

  @override
  State<CardFormDialog> createState() => _CardFormDialogState();
}

class _CardFormDialogState extends State<CardFormDialog> {
  late final _titleController = TextEditingController(text: widget.item?.title);
  late final _cardholderController = TextEditingController(
    text: widget.item?.cardholderName,
  );
  late final _cardNumberController = TextEditingController(
    text: widget.item?.cardNumber,
  );
  late final _expiryController = TextEditingController(
    text: widget.item?.expiry,
  );
  late final _cvvController = TextEditingController(text: widget.item?.cvv);
  late List<VaultFolder> _folders = widget.folders;
  late String? _folderId = widget.item?.folderId;
  bool _obscureNumber = true;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_handleChanged);
    _cardNumberController.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cardholderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
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
            ? l10n.secureVaultEditCardTitle
            : l10n.secureVaultNewCardTitle,
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
              label: l10n.secureVaultCardholderLabel,
              controller: _cardholderController,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextField(
              controller: _cardNumberController,
              obscureText: _obscureNumber,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.secureVaultCardNumberLabel,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNumber
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscureNumber = !_obscureNumber),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.secureVaultExpiryLabel,
                    controller: _expiryController,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: AppTextField(
                    label: l10n.secureVaultCvvLabel,
                    controller: _cvvController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
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
                  _cardNumberController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  CardFormResult(
                    title: _titleController.text.trim(),
                    cardholderName: _cardholderController.text.trim(),
                    cardNumber: _cardNumberController.text.trim(),
                    expiry: _expiryController.text.trim(),
                    cvv: _cvvController.text.trim().isEmpty
                        ? null
                        : _cvvController.text.trim(),
                    folderId: _folderId,
                  ),
                ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
