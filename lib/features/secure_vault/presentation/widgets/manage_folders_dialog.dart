import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/presentation/providers/secure_vault_controller.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_folder_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog listing every [VaultFolder], letting the user add new ones or
/// delete existing ones.
class ManageFoldersDialog extends ConsumerWidget {
  const ManageFoldersDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(secureVaultControllerProvider.notifier);
    final folders = ref.watch(secureVaultControllerProvider).folders;

    return AlertDialog(
      title: Text(l10n.secureVaultFolderLabel),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (folders.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacingMd,
                ),
                child: Text(l10n.secureVaultNoFolder),
              )
            else
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: folders
                    .map(
                      (folder) => FolderChip(
                        folder: folder,
                        onDeleted: () => _confirmDelete(
                          context,
                          ref,
                          folder.id,
                          folder.name,
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: AppDimensions.spacingMd),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l10n.secureVaultNewFolder),
              onPressed: () async {
                final created = await showDialog<VaultFolder>(
                  context: context,
                  builder: (context) => const CreateFolderDialog(),
                );
                if (created != null) {
                  controller.createFolder(
                    name: created.name,
                    colorValue: created.colorValue,
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonConfirm),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String folderId,
    String folderName,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppAlertDialog.show(
      context,
      title: l10n.secureVaultDeleteFolderTitle,
      message: '$folderName — ${l10n.secureVaultDeleteFolderMessage}',
      confirmLabel: l10n.commonConfirm,
      cancelLabel: l10n.commonCancel,
    );
    if (confirmed) {
      ref.read(secureVaultControllerProvider.notifier).deleteFolder(folderId);
    }
  }
}
