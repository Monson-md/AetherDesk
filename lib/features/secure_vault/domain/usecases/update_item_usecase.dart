import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class UpdateItemUseCase {
  const UpdateItemUseCase(this._repository);
  final SecureVaultRepository _repository;

  VaultItem call(VaultItem item) => _repository.updateItem(item);
}
