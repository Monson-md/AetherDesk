import 'package:aetherdesk/core/services/encryption/encryption_service_provider.dart';
import 'package:aetherdesk/features/secure_vault/data/repositories/secure_vault_repository_impl.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/create_api_key_usecase.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/create_card_usecase.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/create_document_usecase.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/create_folder_usecase.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/create_password_usecase.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/create_secure_note_usecase.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/delete_folder_usecase.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/delete_item_usecase.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/set_item_favorite_usecase.dart';
import 'package:aetherdesk/features/secure_vault/domain/usecases/update_item_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureVaultRepositoryProvider = Provider<SecureVaultRepository>((ref) {
  return SecureVaultRepositoryImpl(ref.watch(encryptionServiceProvider));
});

final createFolderUseCaseProvider = Provider<CreateFolderUseCase>((ref) {
  return CreateFolderUseCase(ref.watch(secureVaultRepositoryProvider));
});

final deleteFolderUseCaseProvider = Provider<DeleteFolderUseCase>((ref) {
  return DeleteFolderUseCase(ref.watch(secureVaultRepositoryProvider));
});

final createSecureNoteUseCaseProvider = Provider<CreateSecureNoteUseCase>((
  ref,
) {
  return CreateSecureNoteUseCase(ref.watch(secureVaultRepositoryProvider));
});

final createPasswordUseCaseProvider = Provider<CreatePasswordUseCase>((ref) {
  return CreatePasswordUseCase(ref.watch(secureVaultRepositoryProvider));
});

final createApiKeyUseCaseProvider = Provider<CreateApiKeyUseCase>((ref) {
  return CreateApiKeyUseCase(ref.watch(secureVaultRepositoryProvider));
});

final createCardUseCaseProvider = Provider<CreateCardUseCase>((ref) {
  return CreateCardUseCase(ref.watch(secureVaultRepositoryProvider));
});

final createDocumentUseCaseProvider = Provider<CreateDocumentUseCase>((ref) {
  return CreateDocumentUseCase(ref.watch(secureVaultRepositoryProvider));
});

final updateItemUseCaseProvider = Provider<UpdateItemUseCase>((ref) {
  return UpdateItemUseCase(ref.watch(secureVaultRepositoryProvider));
});

final setItemFavoriteUseCaseProvider = Provider<SetItemFavoriteUseCase>((ref) {
  return SetItemFavoriteUseCase(ref.watch(secureVaultRepositoryProvider));
});

final deleteItemUseCaseProvider = Provider<DeleteItemUseCase>((ref) {
  return DeleteItemUseCase(ref.watch(secureVaultRepositoryProvider));
});
