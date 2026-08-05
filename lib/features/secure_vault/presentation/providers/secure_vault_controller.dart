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
///
/// This is an [AsyncNotifier] (rather than the plain [Notifier] used
/// elsewhere in the app) because the real, disk-backed
/// `SecureVaultRepository` loads asynchronously on first access.
class SecureVaultController extends AsyncNotifier<SecureVaultState> {
  @override
  Future<SecureVaultState> build() async {
    final repository = ref.read(secureVaultRepositoryProvider);
    final items = await repository.getItems();
    final folders = await repository.getFolders();
    return SecureVaultState(items: items, folders: folders);
  }

  /// The last successfully loaded state, or an empty one while the initial
  /// load/a mutation is in flight. Convenience for callers that need a
  /// synchronous read (e.g. populating a dropdown) rather than watching
  /// [AsyncValue].
  SecureVaultState get currentState => state.value ?? const SecureVaultState();

  Future<void> createFolder({
    required String name,
    required int colorValue,
  }) async {
    final folder = await ref
        .read(createFolderUseCaseProvider)
        .call(name: name, colorValue: colorValue);
    state = AsyncData(
      currentState.copyWith(folders: [...currentState.folders, folder]),
    );
  }

  Future<void> deleteFolder(String folderId) async {
    await ref.read(deleteFolderUseCaseProvider).call(folderId);
    state = AsyncData(
      currentState.copyWith(
        folders: currentState.folders
            .where((folder) => folder.id != folderId)
            .toList(),
        items: currentState.items
            .map(
              (item) => item.folderId == folderId ? _withoutFolder(item) : item,
            )
            .toList(),
      ),
    );
  }

  Future<void> createSecureNote({
    required String title,
    required String content,
    String? folderId,
  }) async {
    final item = await ref
        .read(createSecureNoteUseCaseProvider)
        .call(title: title, content: content, folderId: folderId);
    _appendItem(item);
  }

  Future<void> createPassword({
    required String title,
    required String username,
    required String password,
    String? url,
    String? folderId,
  }) async {
    final item = await ref
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

  Future<void> createApiKey({
    required String title,
    required String service,
    required String apiKey,
    String? folderId,
  }) async {
    final item = await ref
        .read(createApiKeyUseCaseProvider)
        .call(
          title: title,
          service: service,
          apiKey: apiKey,
          folderId: folderId,
        );
    _appendItem(item);
  }

  Future<void> createCard({
    required String title,
    required String cardholderName,
    required String cardNumber,
    required String expiry,
    String? cvv,
    String? folderId,
  }) async {
    final item = await ref
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

  Future<void> createDocument({
    required String title,
    required String fileName,
    String? notes,
    String? folderId,
  }) async {
    final item = await ref
        .read(createDocumentUseCaseProvider)
        .call(
          title: title,
          fileName: fileName,
          notes: notes,
          folderId: folderId,
        );
    _appendItem(item);
  }

  Future<void> updateItem(VaultItem item) async {
    final updated = await ref.read(updateItemUseCaseProvider).call(item);
    state = AsyncData(currentState.copyWith(items: _replaceItem(updated)));
  }

  Future<void> setItemFavorite(
    String itemId, {
    required bool isFavorite,
  }) async {
    final updated = await ref
        .read(setItemFavoriteUseCaseProvider)
        .call(itemId, isFavorite: isFavorite);
    state = AsyncData(currentState.copyWith(items: _replaceItem(updated)));
  }

  Future<void> deleteItem(String itemId) async {
    await ref.read(deleteItemUseCaseProvider).call(itemId);
    state = AsyncData(
      currentState.copyWith(
        items: currentState.items.where((item) => item.id != itemId).toList(),
      ),
    );
  }

  void setSearchQuery(String query) {
    state = AsyncData(currentState.copyWith(searchQuery: query));
  }

  void setSortOption(VaultSortOption option) {
    state = AsyncData(currentState.copyWith(sortOption: option));
  }

  void setFolderFilter(String? folderId) {
    state = AsyncData(
      currentState.copyWith(
        filterFolderId: folderId,
        clearFilterFolder: folderId == null,
      ),
    );
  }

  void setTypeFilter(VaultItemType? type) {
    state = AsyncData(
      currentState.copyWith(filterType: type, clearFilterType: type == null),
    );
  }

  void setFavoritesOnly(bool value) {
    state = AsyncData(currentState.copyWith(favoritesOnly: value));
  }

  void _appendItem(VaultItem item) {
    state = AsyncData(
      currentState.copyWith(items: [...currentState.items, item]),
    );
  }

  List<VaultItem> _replaceItem(VaultItem updated) {
    return currentState.items
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
    AsyncNotifierProvider<SecureVaultController, SecureVaultState>(
      SecureVaultController.new,
    );

/// Derived, read-only view of [secureVaultControllerProvider]'s items after
/// applying the current search/sort/filter selections.
final filteredVaultItemsProvider = Provider<List<VaultItem>>((ref) {
  final state =
      ref.watch(secureVaultControllerProvider).value ??
      const SecureVaultState();
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
