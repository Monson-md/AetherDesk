import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/error/error_handler.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/services/biometric/biometric_auth_service_provider.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item_type.dart';
import 'package:aetherdesk/features/secure_vault/presentation/providers/secure_vault_controller.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/api_key_form_dialog.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/card_form_dialog.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/document_form_dialog.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/manage_folders_dialog.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/password_form_dialog.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/secure_note_form_dialog.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_filter_bar.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_item_card.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_item_type_widgets.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_search_field.dart';
import 'package:aetherdesk/features/secure_vault/presentation/widgets/vault_sort_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `secure_vault` module: search/sort/filter toolbar
/// over a list of [VaultItemCard]s, with entry points to add an item (of
/// any of the five types) or manage folders. Gated behind a real biometric
/// prompt (`BiometricAuthService`) whenever the device reports hardware
/// support; otherwise the vault opens directly, same as before.
class SecureVaultHomePage extends ConsumerStatefulWidget {
  const SecureVaultHomePage({super.key});

  @override
  ConsumerState<SecureVaultHomePage> createState() =>
      _SecureVaultHomePageState();
}

class _SecureVaultHomePageState extends ConsumerState<SecureVaultHomePage> {
  bool _isChecking = true;
  bool _isUnlocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryUnlock());
  }

  Future<void> _tryUnlock() async {
    setState(() => _isChecking = true);
    final biometricService = ref.read(biometricAuthServiceProvider);
    final available = await biometricService.isAvailable();
    if (!available) {
      if (!mounted) return;
      setState(() {
        _isUnlocked = true;
        _isChecking = false;
      });
      return;
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final success = await biometricService.authenticate(
      reason: l10n.secureVaultBiometricPromptReason,
    );
    if (!mounted) return;
    setState(() {
      _isUnlocked = success;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.secureVault);

    if (_isChecking) {
      return Scaffold(
        appBar: AppBar(title: Text(destination.label)),
        body: const AppLoadingIndicator(),
      );
    }

    if (!_isUnlocked) {
      return Scaffold(
        appBar: AppBar(title: Text(destination.label)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Text(l10n.secureVaultLockedTitle),
                const SizedBox(height: AppDimensions.spacingLg),
                PrimaryButton(
                  label: l10n.secureVaultUnlockButton,
                  onPressed: _tryUnlock,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final asyncState = ref.watch(secureVaultControllerProvider);
    return asyncState.when(
      data: (state) => _buildContent(context, destination.label, state),
      loading: () => Scaffold(
        appBar: AppBar(title: Text(destination.label)),
        body: const AppLoadingIndicator(),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: Text(destination.label)),
        body: ErrorView(
          failure: mapExceptionToFailure(error),
          onRetry: () => ref.invalidate(secureVaultControllerProvider),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    String title,
    SecureVaultState state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(secureVaultControllerProvider.notifier);
    final filteredItems = ref.watch(filteredVaultItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_outlined),
            tooltip: l10n.secureVaultFolderLabel,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => const ManageFoldersDialog(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemMenu(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.secureVaultNewItem),
      ),
      body: ResponsiveContentWrapper(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: VaultSearchField(
                      initialValue: state.searchQuery,
                      onChanged: controller.setSearchQuery,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  VaultSortMenu(
                    value: state.sortOption,
                    onChanged: controller.setSortOption,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              VaultFilterBar(
                folders: state.folders,
                selectedFolderId: state.filterFolderId,
                onFolderChanged: controller.setFolderFilter,
                selectedType: state.filterType,
                onTypeChanged: controller.setTypeFilter,
                favoritesOnly: state.favoritesOnly,
                onFavoritesOnlyChanged: controller.setFavoritesOnly,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Expanded(
                child: state.items.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.lock_outline,
                        title: l10n.secureVaultEmptyTitle,
                        message: l10n.secureVaultEmptyMessage,
                      )
                    : filteredItems.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.search_off,
                        title: l10n.secureVaultNoResultsTitle,
                        message: l10n.secureVaultNoResultsMessage,
                      )
                    : _VaultItemGrid(
                        items: filteredItems,
                        folders: state.folders,
                        onEdit: (item) => _editItem(context, item),
                        onDelete: (item) => _deleteItem(context, item),
                        onFavoriteToggle: (item) => controller.setItemFavorite(
                          item.id,
                          isFavorite: !item.isFavorite,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddItemMenu(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final type = await showModalBottomSheet<VaultItemType>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: VaultItemType.values
              .map(
                (type) => ListTile(
                  leading: Icon(type.icon),
                  title: Text(type.label(l10n)),
                  onTap: () => Navigator.of(context).pop(type),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (type == null || !context.mounted) return;
    await _addItem(context, type);
  }

  Future<VaultFolder?> _persistNewFolder(String name, int colorValue) async {
    final controller = ref.read(secureVaultControllerProvider.notifier);
    await controller.createFolder(name: name, colorValue: colorValue);
    final folders = controller.currentState.folders;
    return folders.isEmpty ? null : folders.last;
  }

  Future<void> _addItem(BuildContext context, VaultItemType type) async {
    final controller = ref.read(secureVaultControllerProvider.notifier);
    final folders = controller.currentState.folders;

    switch (type) {
      case VaultItemType.secureNote:
        final result = await showDialog<SecureNoteFormResult>(
          context: context,
          builder: (context) => SecureNoteFormDialog(
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.createSecureNote(
          title: result.title,
          content: result.content,
          folderId: result.folderId,
        );
      case VaultItemType.password:
        final result = await showDialog<PasswordFormResult>(
          context: context,
          builder: (context) => PasswordFormDialog(
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.createPassword(
          title: result.title,
          username: result.username,
          password: result.password,
          url: result.url,
          folderId: result.folderId,
        );
      case VaultItemType.apiKey:
        final result = await showDialog<ApiKeyFormResult>(
          context: context,
          builder: (context) => ApiKeyFormDialog(
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.createApiKey(
          title: result.title,
          service: result.service,
          apiKey: result.apiKey,
          folderId: result.folderId,
        );
      case VaultItemType.card:
        final result = await showDialog<CardFormResult>(
          context: context,
          builder: (context) => CardFormDialog(
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.createCard(
          title: result.title,
          cardholderName: result.cardholderName,
          cardNumber: result.cardNumber,
          expiry: result.expiry,
          cvv: result.cvv,
          folderId: result.folderId,
        );
      case VaultItemType.document:
        final result = await showDialog<DocumentFormResult>(
          context: context,
          builder: (context) => DocumentFormDialog(
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.createDocument(
          title: result.title,
          fileName: result.fileName,
          notes: result.notes,
          folderId: result.folderId,
        );
    }
  }

  Future<void> _editItem(BuildContext context, VaultItem item) async {
    final controller = ref.read(secureVaultControllerProvider.notifier);
    final folders = controller.currentState.folders;

    switch (item) {
      case SecureNoteItem():
        final result = await showDialog<SecureNoteFormResult>(
          context: context,
          builder: (context) => SecureNoteFormDialog(
            item: item,
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.updateItem(
          SecureNoteItem(
            id: item.id,
            title: result.title,
            folderId: result.folderId,
            isFavorite: item.isFavorite,
            createdAt: item.createdAt,
            content: result.content,
          ),
        );
      case PasswordItem():
        final result = await showDialog<PasswordFormResult>(
          context: context,
          builder: (context) => PasswordFormDialog(
            item: item,
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.updateItem(
          PasswordItem(
            id: item.id,
            title: result.title,
            folderId: result.folderId,
            isFavorite: item.isFavorite,
            createdAt: item.createdAt,
            username: result.username,
            password: result.password,
            url: result.url,
          ),
        );
      case ApiKeyItem():
        final result = await showDialog<ApiKeyFormResult>(
          context: context,
          builder: (context) => ApiKeyFormDialog(
            item: item,
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.updateItem(
          ApiKeyItem(
            id: item.id,
            title: result.title,
            folderId: result.folderId,
            isFavorite: item.isFavorite,
            createdAt: item.createdAt,
            service: result.service,
            apiKey: result.apiKey,
          ),
        );
      case CardItem():
        final result = await showDialog<CardFormResult>(
          context: context,
          builder: (context) => CardFormDialog(
            item: item,
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.updateItem(
          CardItem(
            id: item.id,
            title: result.title,
            folderId: result.folderId,
            isFavorite: item.isFavorite,
            createdAt: item.createdAt,
            cardholderName: result.cardholderName,
            cardNumber: result.cardNumber,
            expiry: result.expiry,
            cvv: result.cvv,
          ),
        );
      case DocumentItem():
        final result = await showDialog<DocumentFormResult>(
          context: context,
          builder: (context) => DocumentFormDialog(
            item: item,
            folders: folders,
            onCreateFolder: _persistNewFolder,
          ),
        );
        if (result == null) return;
        await controller.updateItem(
          DocumentItem(
            id: item.id,
            title: result.title,
            folderId: result.folderId,
            isFavorite: item.isFavorite,
            createdAt: item.createdAt,
            fileName: result.fileName,
            notes: result.notes,
          ),
        );
    }
  }

  Future<void> _deleteItem(BuildContext context, VaultItem item) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppAlertDialog.show(
      context,
      title: l10n.secureVaultDeleteItemTitle,
      message: '${item.title} — ${l10n.secureVaultDeleteItemMessage}',
      confirmLabel: l10n.commonConfirm,
      cancelLabel: l10n.commonCancel,
    );
    if (confirmed) {
      await ref
          .read(secureVaultControllerProvider.notifier)
          .deleteItem(item.id);
    }
  }
}

class _VaultItemGrid extends StatelessWidget {
  const _VaultItemGrid({
    required this.items,
    required this.folders,
    required this.onEdit,
    required this.onDelete,
    required this.onFavoriteToggle,
  });

  final List<VaultItem> items;
  final List<VaultFolder> folders;
  final ValueChanged<VaultItem> onEdit;
  final ValueChanged<VaultItem> onDelete;
  final ValueChanged<VaultItem> onFavoriteToggle;

  VaultFolder? _folderFor(String? folderId) {
    for (final folder in folders) {
      if (folder.id == folderId) return folder;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 360).floor().clamp(1, 3);
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppDimensions.spacingMd,
            crossAxisSpacing: AppDimensions.spacingMd,
            childAspectRatio: 1.6,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return VaultItemCard(
              item: item,
              folder: _folderFor(item.folderId),
              onEdit: () => onEdit(item),
              onDelete: () => onDelete(item),
              onFavoriteToggle: () => onFavoriteToggle(item),
            );
          },
        );
      },
    );
  }
}
