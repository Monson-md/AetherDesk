import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:flutter/material.dart';

/// A bounded, curated set of colors a user can assign to a [VaultFolder].
const List<Color> folderColorPalette = [
  Color(0xFFEF4444),
  Color(0xFFF97316),
  Color(0xFFF59E0B),
  Color(0xFF22C55E),
  Color(0xFF14B8A6),
  Color(0xFF3B82F6),
  Color(0xFF8B5CF6),
  Color(0xFFEC4899),
];

/// Small colored chip showing a folder's name, with an optional delete
/// action.
class FolderChip extends StatelessWidget {
  const FolderChip({required this.folder, this.onDeleted, super.key});

  final VaultFolder folder;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final color = Color(folder.colorValue);
    return Chip(
      avatar: Icon(Icons.folder, color: color, size: 16),
      label: Text(folder.name),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      onDeleted: onDeleted,
    );
  }
}

/// Dropdown for picking an optional [VaultFolder], with a button to create
/// a new one inline.
class FolderPickerField extends StatelessWidget {
  const FolderPickerField({
    required this.folders,
    required this.value,
    required this.onChanged,
    required this.onCreateFolder,
    super.key,
  });

  final List<VaultFolder> folders;
  final String? value;
  final ValueChanged<String?> onChanged;
  final VoidCallback onCreateFolder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String?>(
            initialValue: value,
            decoration: InputDecoration(labelText: l10n.secureVaultFolderLabel),
            items: [
              DropdownMenuItem(child: Text(l10n.secureVaultNoFolder)),
              ...folders.map(
                (folder) => DropdownMenuItem(
                  value: folder.id,
                  child: Text(folder.name),
                ),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        IconButton(
          onPressed: onCreateFolder,
          icon: const Icon(Icons.create_new_folder_outlined),
          tooltip: l10n.secureVaultNewFolder,
        ),
      ],
    );
  }
}

/// Dialog to create a new [VaultFolder]: a name field plus a swatch picker
/// over [folderColorPalette].
class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final _nameController = TextEditingController();
  Color _selectedColor = folderColorPalette.first;

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
    return AlertDialog(
      title: Text(l10n.secureVaultNewFolder),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            label: l10n.secureVaultFolderNameHint,
            controller: _nameController,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: folderColorPalette.map((color) {
              final isSelected = color.toARGB32() == _selectedColor.toARGB32();
              return InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                onTap: () => setState(() => _selectedColor = color),
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: isSelected ? 16 : 14,
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _nameController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  VaultFolder(
                    id: '',
                    name: _nameController.text.trim(),
                    colorValue: _selectedColor.toARGB32(),
                  ),
                ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
