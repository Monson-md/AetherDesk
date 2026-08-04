import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item_type.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_sort_option.dart';
import 'package:aetherdesk/features/secure_vault/presentation/providers/secure_vault_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureVaultState {
  const SecureVaultState({
    this.items = const [],
    this.folders = const [],
    this.searchQuery = '',
    this.sortOption = VaultSortOption.title,
    this.filterFolderId,
    this.filterType,
    this.favoritesOnly = false,
  });

  final List<VaultItem> items;
  final List<VaultFolder> folders;
  final String searchQuery;
  final VaultSortOption sortOption;
  final String? filterFolderId;
  final VaultItemType? filterType;
  final bool favoritesOnly;

  SecureVaultState copyWith({
    List<VaultItem>? items,
    List<VaultFolder>? folders,
    String? searchQuery,
    VaultSortOption? sortOption,
    String? filterFolderId,
    bool clearFilterFolder = false,
    VaultItemType? filterType,
    bool clearFilterType = false,
    bool? favoritesOnly,
  }) {
    return SecureVaultState(
      items: items ?? this.items,
      folders: folders ?? this.folders,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      filterFolderId: clearFilterFolder
          ? null
          : (filterFolderId ?? this.filterFolderId),
      filterType: clearFilterType ? null : (filterType ?? this.filterType),
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    );
  }
}

/// Screen state for the whole `secure_vault` module: the raw item/folder
/// collections plus the dashboard's search/sort/filter selections. Derived
/// results are exposed via [filteredVaultItemsProvider].
class SecureVaultController extends Notifier<SecureVaultState> {
  @override
  SecureVaultState build() {
    final repository = ref.read(secureVaultRepositoryProvider);
    return SecureVaultState(
      items: repository.getItems(),
      folders: repository.getFolders(),
    );
  }

  void createFolder({required String name, required int colorValue}) {
    final folder = ref
        .read(createFolderUseCaseProvider)
        .call(name: name, colorValue: colorValue);
    state = state.copyWith(folders: [...state.folders, folder]);
  }

  void deleteFolder(String folderId) {
    ref.read(deleteFolderUseCaseProvider).call(folderId);
    state = state.copyWith(
      folders: state.folders.where((folder) => folder.id != folderId).toList(),
      items: state.items
          .map(
            (item) => item.folderId == folderId ? _withoutFolder(item) : item,
          )
          .toList(),
    );
  }

  void createSecureNote({
    required String title,
    required String content,
    String? folderId,
  }) {
    final item = ref
        .read(createSecureNoteUseCaseProvider)
        .call(title: title, content: content, folderId: folderId);
    _appendItem(item);
  }

  void createPassword({
    required String title,
    required String username,
    required String password,
    String? url,
    String? folderId,
  }) {
    final item = ref
        .read(createPasswordUseCaseProvider)
        .call(
          title: title,
          username: username,
          password: password,
          url: url,
          folderId: folderId,
        );
    _appendItem(item);
  }

  void createApiKey({
    required String title,
    required String service,
    required String apiKey,
    String? folderId,
  }) {
    final item = ref
        .read(createApiKeyUseCaseProvider)
        .call(
          title: title,
          service: service,
          apiKey: apiKey,
          folderId: folderId,
        );
    _appendItem(item);
  }

  void createCard({
    required String title,
    required String cardholderName,
    required String cardNumber,
    required String expiry,
    String? cvv,
    String? folderId,
  }) {
    final item = ref
        .read(createCardUseCaseProvider)
        .call(
          title: title,
          cardholderName: cardholderName,
          cardNumber: cardNumber,
          expiry: expiry,
          cvv: cvv,
          folderId: folderId,
        );
    _appendItem(item);
  }

  void createDocument({
    required String title,
    required String fileName,
    String? notes,
    String? folderId,
  }) {
    final item = ref
        .read(createDocumentUseCaseProvider)
        .call(
          title: title,
          fileName: fileName,
          notes: notes,
          folderId: folderId,
        );
    _appendItem(item);
  }

  void updateItem(VaultItem item) {
    final updated = ref.read(updateItemUseCaseProvider).call(item);
    state = state.copyWith(items: _replaceItem(updated));
  }

  void setItemFavorite(String itemId, {required bool isFavorite}) {
    final updated = ref
        .read(setItemFavoriteUseCaseProvider)
        .call(itemId, isFavorite: isFavorite);
    state = state.copyWith(items: _replaceItem(updated));
  }

  void deleteItem(String itemId) {
    ref.read(deleteItemUseCaseProvider).call(itemId);
    state = state.copyWith(
      items: state.items.where((item) => item.id != itemId).toList(),
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSortOption(VaultSortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void setFolderFilter(String? folderId) {
    state = state.copyWith(
      filterFolderId: folderId,
      clearFilterFolder: folderId == null,
    );
  }

  void setTypeFilter(VaultItemType? type) {
    state = state.copyWith(filterType: type, clearFilterType: type == null);
  }

  void setFavoritesOnly(bool value) {
    state = state.copyWith(favoritesOnly: value);
  }

  void _appendItem(VaultItem item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  List<VaultItem> _replaceItem(VaultItem updated) {
    return state.items
        .map((item) => item.id == updated.id ? updated : item)
        .toList();
  }

  VaultItem _withoutFolder(VaultItem item) => switch (item) {
    SecureNoteItem() => SecureNoteItem(
      id: item.id,
      title: item.title,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      content: item.content,
    ),
    PasswordItem() => PasswordItem(
      id: item.id,
      title: item.title,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      username: item.username,
      password: item.password,
      url: item.url,
    ),
    ApiKeyItem() => ApiKeyItem(
      id: item.id,
      title: item.title,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      service: item.service,
      apiKey: item.apiKey,
    ),
    CardItem() => CardItem(
      id: item.id,
      title: item.title,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      cardholderName: item.cardholderName,
      cardNumber: item.cardNumber,
      expiry: item.expiry,
      cvv: item.cvv,
    ),
    DocumentItem() => DocumentItem(
      id: item.id,
      title: item.title,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      fileName: item.fileName,
      notes: item.notes,
    ),
  };
}

final secureVaultControllerProvider =
    NotifierProvider<SecureVaultController, SecureVaultState>(
      SecureVaultController.new,
    );

/// Derived, read-only view of [secureVaultControllerProvider]'s items after
/// applying the current search/sort/filter selections.
final filteredVaultItemsProvider = Provider<List<VaultItem>>((ref) {
  final state = ref.watch(secureVaultControllerProvider);
  final query = state.searchQuery.trim().toLowerCase();

  final filtered = state.items.where((item) {
    if (state.favoritesOnly && !item.isFavorite) return false;
    if (state.filterFolderId != null && item.folderId != state.filterFolderId) {
      return false;
    }
    if (state.filterType != null && item.type != state.filterType) return false;
    if (query.isEmpty) return true;
    return item.title.toLowerCase().contains(query);
  }).toList();

  filtered.sort(_comparatorFor(state.sortOption));
  return filtered;
});

int Function(VaultItem, VaultItem) _comparatorFor(VaultSortOption option) {
  switch (option) {
    case VaultSortOption.title:
      return (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase());
    case VaultSortOption.createdAt:
      return (a, b) => b.createdAt.compareTo(a.createdAt);
    case VaultSortOption.type:
      return (a, b) => a.type.index.compareTo(b.type.index);
  }
}
