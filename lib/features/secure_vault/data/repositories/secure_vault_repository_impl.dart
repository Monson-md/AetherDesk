import 'package:aetherdesk/core/services/encryption/encryption_service.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

/// In-memory implementation of [SecureVaultRepository] — no disk I/O, no
/// backend. See `vault_item.dart`'s doc comment: secret fields are held
/// encrypted at rest in [_items] via [_encryptionService], and every method
/// that returns a [VaultItem] to a caller returns the decrypted (plain
/// text) form. A future implementation backed by real local storage can
/// replace this file without any change to `domain/` or `presentation/`.
class SecureVaultRepositoryImpl implements SecureVaultRepository {
  SecureVaultRepositoryImpl(this._encryptionService);

  final EncryptionService _encryptionService;
  final List<VaultFolder> _folders = [];

  /// Holds each item with its secret field(s) already encrypted — never
  /// exposed directly to callers.
  final List<VaultItem> _items = [];

  int _folderIdCounter = 0;
  int _itemIdCounter = 0;

  @override
  List<VaultFolder> getFolders() => List.unmodifiable(_folders);

  @override
  List<VaultItem> getItems() => _items.map(_decrypted).toList();

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
    final plain = SecureNoteItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      content: content,
    );
    _items.add(_encrypted(plain));
    return plain;
  }

  @override
  PasswordItem createPassword({
    required String title,
    required String username,
    required String password,
    String? url,
    String? folderId,
  }) {
    final plain = PasswordItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      username: username,
      password: password,
      url: url,
    );
    _items.add(_encrypted(plain));
    return plain;
  }

  @override
  ApiKeyItem createApiKey({
    required String title,
    required String service,
    required String apiKey,
    String? folderId,
  }) {
    final plain = ApiKeyItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      service: service,
      apiKey: apiKey,
    );
    _items.add(_encrypted(plain));
    return plain;
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
    final plain = CardItem(
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
    _items.add(_encrypted(plain));
    return plain;
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
    _items[index] = _encrypted(item);
    return item;
  }

  @override
  VaultItem setItemFavorite(String itemId, {required bool isFavorite}) {
    final index = _items.indexWhere((item) => item.id == itemId);
    final updated = _withFavorite(_items[index], isFavorite: isFavorite);
    _items[index] = updated;
    return _decrypted(updated);
  }

  @override
  void deleteItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
  }

  String _nextItemId() => 'item-${++_itemIdCounter}';

  /// Returns [item] with its secret field(s) run through
  /// [EncryptionService.encrypt] — used before storing.
  VaultItem _encrypted(VaultItem item) => switch (item) {
    SecureNoteItem() => SecureNoteItem(
      id: item.id,
      title: item.title,
      folderId: item.folderId,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      content: _encryptionService.encrypt(item.content),
    ),
    PasswordItem() => PasswordItem(
      id: item.id,
      title: item.title,
      folderId: item.folderId,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      username: item.username,
      password: _encryptionService.encrypt(item.password),
      url: item.url,
    ),
    ApiKeyItem() => ApiKeyItem(
      id: item.id,
      title: item.title,
      folderId: item.folderId,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      service: item.service,
      apiKey: _encryptionService.encrypt(item.apiKey),
    ),
    CardItem() => CardItem(
      id: item.id,
      title: item.title,
      folderId: item.folderId,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      cardholderName: item.cardholderName,
      cardNumber: _encryptionService.encrypt(item.cardNumber),
      expiry: item.expiry,
      cvv: item.cvv == null ? null : _encryptionService.encrypt(item.cvv!),
    ),
    DocumentItem() => item,
  };

  /// Returns [item] with its secret field(s) run through
  /// [EncryptionService.decrypt] — the inverse of [_encrypted], used before
  /// returning a stored item to a caller.
  VaultItem _decrypted(VaultItem item) => switch (item) {
    SecureNoteItem() => SecureNoteItem(
      id: item.id,
      title: item.title,
      folderId: item.folderId,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      content: _encryptionService.decrypt(item.content),
    ),
    PasswordItem() => PasswordItem(
      id: item.id,
      title: item.title,
      folderId: item.folderId,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      username: item.username,
      password: _encryptionService.decrypt(item.password),
      url: item.url,
    ),
    ApiKeyItem() => ApiKeyItem(
      id: item.id,
      title: item.title,
      folderId: item.folderId,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      service: item.service,
      apiKey: _encryptionService.decrypt(item.apiKey),
    ),
    CardItem() => CardItem(
      id: item.id,
      title: item.title,
      folderId: item.folderId,
      isFavorite: item.isFavorite,
      createdAt: item.createdAt,
      cardholderName: item.cardholderName,
      cardNumber: _encryptionService.decrypt(item.cardNumber),
      expiry: item.expiry,
      cvv: item.cvv == null ? null : _encryptionService.decrypt(item.cvv!),
    ),
    DocumentItem() => item,
  };

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
