import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';

/// Contract for the `secure_vault` module's local store. Real disk
/// persistence (`SecureVaultRepositoryImpl`, backed by
/// `flutter_secure_storage`) means every method is async. See
/// `vault_item.dart`'s doc comment for how secret fields are encrypted at
/// rest internally while every method here still returns plain-text
/// values. [updateItem]/[setItemFavorite] take/return the concrete
/// [VaultItem] subtype directly since each already carries every one of
/// its fields, unlike `project_management`'s nested tasks/checklists.
abstract interface class SecureVaultRepository {
  Future<List<VaultFolder>> getFolders();

  Future<List<VaultItem>> getItems();

  Future<VaultFolder> createFolder({
    required String name,
    required int colorValue,
  });

  Future<void> deleteFolder(String folderId);

  Future<SecureNoteItem> createSecureNote({
    required String title,
    required String content,
    String? folderId,
  });

  Future<PasswordItem> createPassword({
    required String title,
    required String username,
    required String password,
    String? url,
    String? folderId,
  });

  Future<ApiKeyItem> createApiKey({
    required String title,
    required String service,
    required String apiKey,
    String? folderId,
  });

  Future<CardItem> createCard({
    required String title,
    required String cardholderName,
    required String cardNumber,
    required String expiry,
    String? cvv,
    String? folderId,
  });

  Future<DocumentItem> createDocument({
    required String title,
    required String fileName,
    String? notes,
    String? folderId,
  });

  Future<VaultItem> updateItem(VaultItem item);

  Future<VaultItem> setItemFavorite(String itemId, {required bool isFavorite});

  Future<void> deleteItem(String itemId);
}
