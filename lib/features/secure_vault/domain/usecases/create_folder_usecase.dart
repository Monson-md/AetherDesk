import 'package:aetherdesk/features/secure_vault/domain/entities/vault_folder.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class CreateFolderUseCase {
  const CreateFolderUseCase(this._repository);
  final SecureVaultRepository _repository;

  VaultFolder call({required String name, required int colorValue}) =>
      _repository.createFolder(name: name, colorValue: colorValue);
}
