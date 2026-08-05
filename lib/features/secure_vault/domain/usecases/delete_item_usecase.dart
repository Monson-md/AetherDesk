import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class DeleteItemUseCase {
  const DeleteItemUseCase(this._repository);
  final SecureVaultRepository _repository;

  Future<void> call(String itemId) => _repository.deleteItem(itemId);
}
