import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';

/// Contract for the `secure_vault` module's local, in-memory store. No
/// encryption, no disk I/O, no biometric gate — see `vault_item.dart`'s doc
/// comment. [updateItem]/[setItemFavorite] take/return the concrete
/// [VaultItem] subtype directly since each already carries every one of
/// its fields, unlike `project_management`'s nested tasks/checklists.
abstract interface class SecureVaultRepository {
  List<VaultFolder> getFolders();

  List<VaultItem> getItems();

  VaultFolder createFolder({required String name, required int colorValue});

  void deleteFolder(String folderId);

  SecureNoteItem createSecureNote({
    required String title,
    required String content,
    String? folderId,
  });

  PasswordItem createPassword({
    required String title,
    required String username,
    required String password,
    String? url,
    String? folderId,
  });

  ApiKeyItem createApiKey({
    required String title,
    required String service,
    required String apiKey,
    String? folderId,
  });

  CardItem createCard({
    required String title,
    required String cardholderName,
    required String cardNumber,
    required String expiry,
    String? cvv,
    String? folderId,
  });

  DocumentItem createDocument({
    required String title,
    required String fileName,
    String? notes,
    String? folderId,
  });

  VaultItem updateItem(VaultItem item);

  VaultItem setItemFavorite(String itemId, {required bool isFavorite});

  void deleteItem(String itemId);
}
