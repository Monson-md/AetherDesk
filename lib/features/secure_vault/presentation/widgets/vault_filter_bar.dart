import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item_type.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_item_type_widgets.dart';
import 'package:flutter/material.dart';

/// Row of chips letting the dashboard be narrowed down to a folder, an
/// item type and/or favorites only, on top of the free-text search.
class VaultFilterBar extends StatelessWidget {
  const VaultFilterBar({
    required this.folders,
    required this.selectedFolderId,
    required this.onFolderChanged,
    required this.selectedType,
    required this.onTypeChanged,
    required this.favoritesOnly,
    required this.onFavoritesOnlyChanged,
    super.key,
  });

  final List<VaultFolder> folders;
  final String? selectedFolderId;
  final ValueChanged<String?> onFolderChanged;
  final VaultItemType? selectedType;
  final ValueChanged<VaultItemType?> onTypeChanged;
  final bool favoritesOnly;
  final ValueChanged<bool> onFavoritesOnlyChanged;

  String? get _selectedFolderName {
    for (final folder in folders) {
      if (folder.id == selectedFolderId) return folder.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilterChip(
          label: Text(l10n.secureVaultFavoritesOnly),
          avatar: const Icon(Icons.star, size: 18),
          selected: favoritesOnly,
          onSelected: onFavoritesOnlyChanged,
        ),
        if (folders.isNotEmpty)
          _FilterMenuChip<String?>(
            icon: Icons.folder_outlined,
            label: _selectedFolderName ?? l10n.secureVaultAllFolders,
            isActive: selectedFolderId != null,
            items: [
              PopupMenuItem(child: Text(l10n.secureVaultAllFolders)),
              ...folders.map(
                (folder) =>
                    PopupMenuItem(value: folder.id, child: Text(folder.name)),
              ),
            ],
            onSelected: onFolderChanged,
          ),
        _FilterMenuChip<VaultItemType?>(
          icon: Icons.category_outlined,
          label: selectedType?.label(l10n) ?? l10n.secureVaultAllTypes,
          isActive: selectedType != null,
          items: [
            PopupMenuItem(child: Text(l10n.secureVaultAllTypes)),
            ...VaultItemType.values.map(
              (type) =>
                  PopupMenuItem(value: type, child: Text(type.label(l10n))),
            ),
          ],
          onSelected: onTypeChanged,
        ),
      ],
    );
  }
}

class _FilterMenuChip<T> extends StatelessWidget {
  const _FilterMenuChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.items,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final List<PopupMenuItem<T>> items;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<T>(
      itemBuilder: (context) => items,
      onSelected: onSelected,
      child: Chip(
        avatar: Icon(
          icon,
          size: 18,
          color: isActive ? colorScheme.onPrimaryContainer : null,
        ),
        label: Text(label),
        backgroundColor: isActive ? colorScheme.primaryContainer : null,
        side: isActive ? BorderSide(color: colorScheme.primary) : null,
      ),
    );
  }
}
