import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_sort_option.dart';
import 'package:flutter/material.dart';

/// Maps [VaultSortOption] to a localized label, kept in the presentation
/// layer since `domain/entities/` must stay Flutter-free.
extension VaultSortOptionPresentation on VaultSortOption {
  String label(AppLocalizations l10n) => switch (this) {
    VaultSortOption.title => l10n.secureVaultSortTitle,
    VaultSortOption.createdAt => l10n.secureVaultSortCreatedAt,
    VaultSortOption.type => l10n.secureVaultSortType,
  };
}

/// Dropdown for picking how the vault dashboard orders its item list.
class VaultSortMenu extends StatelessWidget {
  const VaultSortMenu({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final VaultSortOption value;
  final ValueChanged<VaultSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonHideUnderline(
      child: DropdownButton<VaultSortOption>(
        value: value,
        icon: const Icon(Icons.sort),
        items: VaultSortOption.values
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(
                  '${l10n.secureVaultSortLabel}: ${option.label(l10n)}',
                ),
              ),
            )
            .toList(),
        onChanged: (option) {
          if (option != null) onChanged(option);
        },
      ),
    );
  }
}
