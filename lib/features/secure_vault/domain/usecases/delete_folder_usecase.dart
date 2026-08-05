import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class DeleteFolderUseCase {
  const DeleteFolderUseCase(this._repository);
  final SecureVaultRepository _repository;

  Future<void> call(String folderId) => _repository.deleteFolder(folderId);
}
