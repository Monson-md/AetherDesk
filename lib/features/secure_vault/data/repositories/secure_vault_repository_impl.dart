import 'dart:convert';

import 'package:aetherdesk/core/services/encryption/encryption_service.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item_type.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Real, disk-backed [SecureVaultRepository]: folders and items are
/// persisted as JSON inside [FlutterSecureStorage] (Android Keystore / iOS
/// Keychain / Windows DPAPI / etc. depending on platform) so they survive
/// an app restart, and every secret field is additionally run through
/// [EncryptionService] before that JSON is ever written — see
/// `vault_item.dart`'s doc comment. Every method that returns a [VaultItem]
/// to a caller returns the decrypted (plain text) form.
class SecureVaultRepositoryImpl implements SecureVaultRepository {
  SecureVaultRepositoryImpl(
    this._encryptionService, {
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _storageKey = 'aetherdesk_vault_store_v1';

  final EncryptionService _encryptionService;
  final FlutterSecureStorage _secureStorage;

  List<VaultFolder> _folders = [];

  /// Holds each item with its secret field(s) already encrypted — never
  /// exposed directly to callers.
  List<VaultItem> _items = [];

  int _folderIdCounter = 0;
  int _itemIdCounter = 0;
  Future<void>? _loadFuture;

  Future<void> _ensureLoaded() => _loadFuture ??= _load();

  Future<void> _load() async {
    final raw = await _secureStorage.read(key: _storageKey);
    if (raw == null) return;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _folders = (decoded['folders'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_folderFromJson)
        .toList();
    _items = (decoded['items'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_itemFromJson)
        .toList();
    _folderIdCounter = decoded['folderIdCounter'] as int;
    _itemIdCounter = decoded['itemIdCounter'] as int;
  }

  Future<void> _persist() {
    final payload = jsonEncode({
      'folders': _folders.map(_folderToJson).toList(),
      'items': _items.map(_itemToJson).toList(),
      'folderIdCounter': _folderIdCounter,
      'itemIdCounter': _itemIdCounter,
    });
    return _secureStorage.write(key: _storageKey, value: payload);
  }

  @override
  Future<List<VaultFolder>> getFolders() async {
    await _ensureLoaded();
    return List.unmodifiable(_folders);
  }

  @override
  Future<List<VaultItem>> getItems() async {
    await _ensureLoaded();
    return Future.wait(_items.map(_decrypted));
  }

  @override
  Future<VaultFolder> createFolder({
    required String name,
    required int colorValue,
  }) async {
    await _ensureLoaded();
    final folder = VaultFolder(
      id: 'folder-${++_folderIdCounter}',
      name: name,
      colorValue: colorValue,
    );
    _folders.add(folder);
    await _persist();
    return folder;
  }

  @override
  Future<void> deleteFolder(String folderId) async {
    await _ensureLoaded();
    _folders.removeWhere((folder) => folder.id == folderId);
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].folderId == folderId) {
        _items[i] = _withFolder(_items[i], folderId: null);
      }
    }
    await _persist();
  }

  @override
  Future<SecureNoteItem> createSecureNote({
    required String title,
    required String content,
    String? folderId,
  }) async {
    await _ensureLoaded();
    final plain = SecureNoteItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      content: content,
    );
    _items.add(await _encrypted(plain));
    await _persist();
    return plain;
  }

  @override
  Future<PasswordItem> createPassword({
    required String title,
    required String username,
    required String password,
    String? url,
    String? folderId,
  }) async {
    await _ensureLoaded();
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
    _items.add(await _encrypted(plain));
    await _persist();
    return plain;
  }

  @override
  Future<ApiKeyItem> createApiKey({
    required String title,
    required String service,
    required String apiKey,
    String? folderId,
  }) async {
    await _ensureLoaded();
    final plain = ApiKeyItem(
      id: _nextItemId(),
      title: title,
      folderId: folderId,
      isFavorite: false,
      createdAt: DateTime.now(),
      service: service,
      apiKey: apiKey,
    );
    _items.add(await _encrypted(plain));
    await _persist();
    return plain;
  }

  @override
  Future<CardItem> createCard({
    required String title,
    required String cardholderName,
    required String cardNumber,
    required String expiry,
    String? cvv,
    String? folderId,
  }) async {
    await _ensureLoaded();
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
    _items.add(await _encrypted(plain));
    await _persist();
    return plain;
  }

  @override
  Future<DocumentItem> createDocument({
    required String title,
    required String fileName,
    String? notes,
    String? folderId,
  }) async {
    await _ensureLoaded();
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
    await _persist();
    return item;
  }

  @override
  Future<VaultItem> updateItem(VaultItem item) async {
    await _ensureLoaded();
    final index = _items.indexWhere((existing) => existing.id == item.id);
    _items[index] = await _encrypted(item);
    await _persist();
    return item;
  }

  @override
  Future<VaultItem> setItemFavorite(
    String itemId, {
    required bool isFavorite,
  }) async {
    await _ensureLoaded();
    final index = _items.indexWhere((item) => item.id == itemId);
    final updated = _withFavorite(_items[index], isFavorite: isFavorite);
    _items[index] = updated;
    await _persist();
    return _decrypted(updated);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await _ensureLoaded();
    _items.removeWhere((item) => item.id == itemId);
    await _persist();
  }

  String _nextItemId() => 'item-${++_itemIdCounter}';

  /// Returns [item] with its secret field(s) run through
  /// [EncryptionService.encrypt] — used before storing.
  Future<VaultItem> _encrypted(VaultItem item) async {
    switch (item) {
      case SecureNoteItem():
        return SecureNoteItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          content: await _encryptionService.encrypt(item.content),
        );
      case PasswordItem():
        return PasswordItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          username: item.username,
          password: await _encryptionService.encrypt(item.password),
          url: item.url,
        );
      case ApiKeyItem():
        return ApiKeyItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          service: item.service,
          apiKey: await _encryptionService.encrypt(item.apiKey),
        );
      case CardItem():
        return CardItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          cardholderName: item.cardholderName,
          cardNumber: await _encryptionService.encrypt(item.cardNumber),
          expiry: item.expiry,
          cvv: item.cvv == null
              ? null
              : await _encryptionService.encrypt(item.cvv!),
        );
      case DocumentItem():
        return item;
    }
  }

  /// Returns [item] with its secret field(s) run through
  /// [EncryptionService.decrypt] — the inverse of [_encrypted], used before
  /// returning a stored item to a caller.
  Future<VaultItem> _decrypted(VaultItem item) async {
    switch (item) {
      case SecureNoteItem():
        return SecureNoteItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          content: await _encryptionService.decrypt(item.content),
        );
      case PasswordItem():
        return PasswordItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          username: item.username,
          password: await _encryptionService.decrypt(item.password),
          url: item.url,
        );
      case ApiKeyItem():
        return ApiKeyItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          service: item.service,
          apiKey: await _encryptionService.decrypt(item.apiKey),
        );
      case CardItem():
        return CardItem(
          id: item.id,
          title: item.title,
          folderId: item.folderId,
          isFavorite: item.isFavorite,
          createdAt: item.createdAt,
          cardholderName: item.cardholderName,
          cardNumber: await _encryptionService.decrypt(item.cardNumber),
          expiry: item.expiry,
          cvv: item.cvv == null
              ? null
              : await _encryptionService.decrypt(item.cvv!),
        );
      case DocumentItem():
        return item;
    }
  }

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

  Map<String, dynamic> _folderToJson(VaultFolder folder) => {
    'id': folder.id,
    'name': folder.name,
    'colorValue': folder.colorValue,
  };

  VaultFolder _folderFromJson(Map<String, dynamic> json) => VaultFolder(
    id: json['id'] as String,
    name: json['name'] as String,
    colorValue: json['colorValue'] as int,
  );

  Map<String, dynamic> _itemToJson(VaultItem item) {
    final base = {
      'id': item.id,
      'title': item.title,
      'folderId': item.folderId,
      'isFavorite': item.isFavorite,
      'createdAt': item.createdAt.toIso8601String(),
      'type': item.type.name,
    };
    return switch (item) {
      SecureNoteItem() => {...base, 'content': item.content},
      PasswordItem() => {
        ...base,
        'username': item.username,
        'password': item.password,
        'url': item.url,
      },
      ApiKeyItem() => {...base, 'service': item.service, 'apiKey': item.apiKey},
      CardItem() => {
        ...base,
        'cardholderName': item.cardholderName,
        'cardNumber': item.cardNumber,
        'expiry': item.expiry,
        'cvv': item.cvv,
      },
      DocumentItem() => {
        ...base,
        'fileName': item.fileName,
        'notes': item.notes,
      },
    };
  }

  VaultItem _itemFromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final title = json['title'] as String;
    final folderId = json['folderId'] as String?;
    final isFavorite = json['isFavorite'] as bool;
    final createdAt = DateTime.parse(json['createdAt'] as String);
    final type = VaultItemType.values.byName(json['type'] as String);
    return switch (type) {
      VaultItemType.secureNote => SecureNoteItem(
        id: id,
        title: title,
        folderId: folderId,
        isFavorite: isFavorite,
        createdAt: createdAt,
        content: json['content'] as String,
      ),
      VaultItemType.password => PasswordItem(
        id: id,
        title: title,
        folderId: folderId,
        isFavorite: isFavorite,
        createdAt: createdAt,
        username: json['username'] as String,
        password: json['password'] as String,
        url: json['url'] as String?,
      ),
      VaultItemType.apiKey => ApiKeyItem(
        id: id,
        title: title,
        folderId: folderId,
        isFavorite: isFavorite,
        createdAt: createdAt,
        service: json['service'] as String,
        apiKey: json['apiKey'] as String,
      ),
      VaultItemType.card => CardItem(
        id: id,
        title: title,
        folderId: folderId,
        isFavorite: isFavorite,
        createdAt: createdAt,
        cardholderName: json['cardholderName'] as String,
        cardNumber: json['cardNumber'] as String,
        expiry: json['expiry'] as String,
        cvv: json['cvv'] as String?,
      ),
      VaultItemType.document => DocumentItem(
        id: id,
        title: title,
        folderId: folderId,
        isFavorite: isFavorite,
        createdAt: createdAt,
        fileName: json['fileName'] as String,
        notes: json['notes'] as String?,
      ),
    };
  }
}
