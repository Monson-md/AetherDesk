import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item_type.dart';
import 'package:flutter/material.dart';

/// Maps [VaultItemType] to a localized label and an icon, kept in the
/// presentation layer since `domain/entities/` must stay Flutter-free.
extension VaultItemTypePresentation on VaultItemType {
  String label(AppLocalizations l10n) => switch (this) {
    VaultItemType.secureNote => l10n.secureVaultTypeSecureNote,
    VaultItemType.password => l10n.secureVaultTypePassword,
    VaultItemType.apiKey => l10n.secureVaultTypeApiKey,
    VaultItemType.card => l10n.secureVaultTypeCard,
    VaultItemType.document => l10n.secureVaultTypeDocument,
  };

  IconData get icon => switch (this) {
    VaultItemType.secureNote => Icons.sticky_note_2_outlined,
    VaultItemType.password => Icons.password_outlined,
    VaultItemType.apiKey => Icons.vpn_key_outlined,
    VaultItemType.card => Icons.credit_card_outlined,
    VaultItemType.document => Icons.description_outlined,
  };
}

/// Small colored icon badge for a [VaultItemType], used on item cards and
/// the "new item" menu.
class VaultItemTypeIcon extends StatelessWidget {
  const VaultItemTypeIcon({required this.type, super.key});

  final VaultItemType type;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingSm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Icon(type.icon, color: color, size: 20),
    );
  }
}
