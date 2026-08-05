import 'dart:math' as math;

import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item_type.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_folder_widgets.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_item_type_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dashboard tile for one [VaultItem]: type icon, title, folder, favorite
/// toggle, edit/delete actions, and a type-specific masked preview with
/// reveal/copy for sensitive fields. Masking here is a UI affordance on
/// top of the values the repository already decrypted for display — see
/// `vault_item.dart`'s doc comment for where the actual (simulated)
/// encryption happens.
class VaultItemCard extends StatefulWidget {
  const VaultItemCard({
    required this.item,
    required this.folder,
    required this.onEdit,
    required this.onDelete,
    required this.onFavoriteToggle,
    super.key,
  });

  final VaultItem item;
  final VaultFolder? folder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onFavoriteToggle;

  @override
  State<VaultItemCard> createState() => _VaultItemCardState();
}

class _VaultItemCardState extends State<VaultItemCard> {
  bool _revealed = false;

  Future<void> _copy(String value) async {
    final l10n = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.secureVaultCopiedMessage)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final item = widget.item;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                VaultItemTypeIcon(type: item.type),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: Text(
                    item.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.type != VaultItemType.document)
                  Tooltip(
                    message: l10n.secureVaultEncryptedAtRestTooltip,
                    child: Icon(
                      Icons.enhanced_encryption_outlined,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.star : Icons.star_border,
                    color: item.isFavorite ? Colors.amber : null,
                  ),
                  tooltip: item.isFavorite
                      ? l10n.secureVaultUnfavoriteTooltip
                      : l10n.secureVaultFavoriteTooltip,
                  onPressed: widget.onFavoriteToggle,
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: widget.onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            _buildBody(context),
            if (widget.folder != null) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              FolderChip(folder: widget.folder!),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleReveal() => setState(() => _revealed = !_revealed);

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return switch (widget.item) {
      SecureNoteItem(:final content) => Text(
        content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium,
      ),
      PasswordItem(:final username, :final password) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (username.isNotEmpty)
            Text(username, style: theme.textTheme.bodyMedium),
          _SecretRow(
            value: password,
            revealed: _revealed,
            onToggleReveal: _toggleReveal,
            onCopy: () => _copy(password),
          ),
        ],
      ),
      ApiKeyItem(:final service, :final apiKey) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (service.isNotEmpty)
            Text(service, style: theme.textTheme.bodyMedium),
          _SecretRow(
            value: apiKey,
            revealed: _revealed,
            onToggleReveal: _toggleReveal,
            onCopy: () => _copy(apiKey),
          ),
        ],
      ),
      CardItem(:final cardholderName, :final cardNumber, :final expiry) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cardholderName, style: theme.textTheme.bodyMedium),
            _SecretRow(
              value: cardNumber,
              revealed: _revealed,
              onToggleReveal: _toggleReveal,
              onCopy: () => _copy(cardNumber),
            ),
            Text(expiry, style: theme.textTheme.bodySmall),
          ],
        ),
      DocumentItem(:final fileName) => Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined, size: 16),
          const SizedBox(width: AppDimensions.spacingXs),
          Expanded(child: Text(fileName, style: theme.textTheme.bodyMedium)),
        ],
      ),
    };
  }
}

class _SecretRow extends StatelessWidget {
  const _SecretRow({
    required this.value,
    required this.revealed,
    required this.onToggleReveal,
    required this.onCopy,
  });

  final String value;
  final bool revealed;
  final VoidCallback onToggleReveal;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            revealed ? value : '•' * math.max(6, math.min(16, value.length)),
            style: theme.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(
            revealed
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          tooltip: revealed
              ? l10n.secureVaultHideTooltip
              : l10n.secureVaultRevealTooltip,
          onPressed: onToggleReveal,
        ),
        IconButton(
          icon: const Icon(Icons.copy_outlined),
          tooltip: l10n.secureVaultCopyTooltip,
          onPressed: onCopy,
        ),
      ],
    );
  }
}
