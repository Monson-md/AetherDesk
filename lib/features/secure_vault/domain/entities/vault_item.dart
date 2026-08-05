import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item_type.dart';

/// Base of the `secure_vault` module's content model. Every stored secret
/// is one of the sealed subtypes below, sharing [id]/[title]/[folderId]/
/// [isFavorite]/[createdAt] but carrying different fields beyond that —
/// hence a sealed hierarchy (like `core/error/failure.dart`'s `Failure`)
/// rather than one class with a pile of nullable fields.
///
/// Persisted for real: `SecureVaultRepositoryImpl` stores every folder/item
/// as JSON inside `flutter_secure_storage`, and secret fields (passwords,
/// API keys, note content, card numbers) are additionally run through a
/// real AES-256-GCM `EncryptionService` before that JSON is written. Every
/// [VaultItem] instance that reaches `domain`/`presentation` (via
/// `getItems()`, `updateItem()`, ...) is already decrypted back to plain
/// text, so nothing outside the repository needs to know encryption is
/// happening. The home page additionally gates access behind
/// `BiometricAuthService` when hardware support is available.
sealed class VaultItem {
  const VaultItem({
    required this.id,
    required this.title,
    this.folderId,
    required this.isFavorite,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String? folderId;
  final bool isFavorite;
  final DateTime createdAt;

  VaultItemType get type => switch (this) {
    SecureNoteItem() => VaultItemType.secureNote,
    PasswordItem() => VaultItemType.password,
    ApiKeyItem() => VaultItemType.apiKey,
    CardItem() => VaultItemType.card,
    DocumentItem() => VaultItemType.document,
  };
}

class SecureNoteItem extends VaultItem {
  const SecureNoteItem({
    required super.id,
    required super.title,
    super.folderId,
    required super.isFavorite,
    required super.createdAt,
    required this.content,
  });

  final String content;
}

class PasswordItem extends VaultItem {
  const PasswordItem({
    required super.id,
    required super.title,
    super.folderId,
    required super.isFavorite,
    required super.createdAt,
    required this.username,
    required this.password,
    this.url,
  });

  final String username;
  final String password;
  final String? url;
}

class ApiKeyItem extends VaultItem {
  const ApiKeyItem({
    required super.id,
    required super.title,
    super.folderId,
    required super.isFavorite,
    required super.createdAt,
    required this.service,
    required this.apiKey,
  });

  final String service;
  final String apiKey;
}

class CardItem extends VaultItem {
  const CardItem({
    required super.id,
    required super.title,
    super.folderId,
    required super.isFavorite,
    required super.createdAt,
    required this.cardholderName,
    required this.cardNumber,
    required this.expiry,
    this.cvv,
  });

  final String cardholderName;
  final String cardNumber;

  /// Free-form `MM/YY` text — not parsed/validated, this is a local mock
  /// vault, not a payment form.
  final String expiry;
  final String? cvv;
}

class DocumentItem extends VaultItem {
  const DocumentItem({
    required super.id,
    required super.title,
    super.folderId,
    required super.isFavorite,
    required super.createdAt,
    required this.fileName,
    this.notes,
  });

  /// Display name only — no real file is attached or read from disk.
  final String fileName;
  final String? notes;
}
