import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

/// In-memory implementation of [SecureVaultRepository] — no disk I/O, no
/// encryption, no backend. See `vault_item.dart`'s doc comment for why: this
/// module is architecture only for now. A future implementation backed by
/// real local storage and encryption can replace this file without any
/// change to `domain/` or `presentation/`.
class SecureVaultRepositoryImpl implements SecureVaultRepository {
  final List<VaultFolder> _folders = [];
  final List<VaultItem> _items = [];

  int _folderIdCounter = 0;
  int _itemIdCounter = 0;

  @override
  List<VaultFolder> getFolders() => List.unmodifiable(_folders);

  @override
  List<VaultItem> getItems() => List.unmodifiable(_items);

  @override
  VaultFolder createFolder({required String name, required int colorValue}) {
    final folder = VaultFolder(
      id: 'folder-${++_folderIdCounter}',
      name: name,
      colorValue: colorValue,
    );
    _folders.add(folder);
    return folder;
  }

  @override
  void deleteFolder(String folderId) {
    _folders.removeWhere((folder) => folder.id == folderId);
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].folderId == folderId) {
        _items[i] = _withFolder(_items[i], folderId: null);
      }
    }
  }

  @override
  SecureNoteItem createSecureNote({
    required String title,
    required String content,
    String? folderId,
  }) {
    final item = SecureNoteItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      content: content,
    );
    _items.add(item);
    return item;
  }

  @override
  PasswordItem createPassword({
    required String title,
    required String username,
    required String password,
    String? url,
    String? folderId,
  }) {
    final item = PasswordItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      username: username,
      password: password,
      url: url,
    );
    _items.add(item);
    return item;
  }

  @override
  ApiKeyItem createApiKey({
    required String title,
    required String service,
    required String apiKey,
    String? folderId,
  }) {
    final item = ApiKeyItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      service: service,
      apiKey: apiKey,
    );
    _items.add(item);
    return item;
  }

  @override
  CardItem createCard({
    required String title,
    required String cardholderName,
    required String cardNumber,
    required String expiry,
    String? cvv,
    String? folderId,
  }) {
    final item = CardItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      cardholderName: cardholderName,
      cardNumber: cardNumber,
      expiry: expiry,
      cvv: cvv,
    );
    _items.add(item);
    return item;
  }

  @override
  DocumentItem createDocument({
    required String title,
    required String fileName,
    String? notes,
    String? folderId,
  }) {
    final item = DocumentItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      fileName: fileName,
      notes: notes,
    );
    _items.add(item);
    return item;
  }

  @override
  VaultItem updateItem(VaultItem item) {
    final index = _items.indexWhere((existing) => existing.id == item.id);
    _items[index] = item;
    return item;
  }

  @override
  VaultItem setItemFavorite(String itemId, {required bool isFavorite}) {
    final index = _items.indexWhere((item) => item.id == itemId);
    final updated = _withFavorite(_items[index], isFavorite: isFavorite);
    _items[index] = updated;
    return updated;
  }

  @override
  void deleteItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
  }

  String _nextItemId() => 'item-${++_itemIdCounter}';

  VaultItem _withFavorite(VaultItem item, {required bool isFavorite}) =>
      switch (item) {
        SecureNoteItem() => SecureNoteItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: isFavorite,
          createdAt: item.createdAt,
          content: item.content,
        ),
        PasswordItem() => PasswordItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: isFavorite,
          createdAt: item.createdAt,
          username: item.username,
          password: item.password,
          url: item.url,
        ),
        ApiKeyItem() => ApiKeyItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: isFavorite,
          createdAt: item.createdAt,
          service: item.service,
          apiKey: item.apiKey,
        ),
        CardItem() => CardItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: isFavorite,
          createdAt: item.createdAt,
          cardholderName: item.cardholderName,
          cardNumber: item.cardNumber,
          expiry: item.expiry,
          cvv: item.cvv,
        ),
        DocumentItem() => DocumentItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: isFavorite,
          createdAt: item.createdAt,
          fileName: item.fileName,
          notes: item.notes,
        ),
      };

  VaultItem _withFolder(VaultItem item, {required String? folderId}) =>
      switch (item) {
        SecureNoteItem() => SecureNoteItem(
          id: item.id,
          title: item.title,
          folderId: folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          content: item.content,
        ),
        PasswordItem() => PasswordItem(
          id: item.id,
          title: item.title,
          folderId: folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          username: item.username,
          password: item.password,
          url: item.url,
        ),
        ApiKeyItem() => ApiKeyItem(
          id: item.id,
          title: item.title,
          folderId: folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          service: item.service,
          apiKey: item.apiKey,
        ),
        CardItem() => CardItem(
          id: item.id,
          title: item.title,
          folderId: folderId,
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
          folderId: folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          fileName: item.fileName,
          notes: item.notes,
        ),
      };
}
