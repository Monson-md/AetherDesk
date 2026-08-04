import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class SetItemFavoriteUseCase {
  const SetItemFavoriteUseCase(this._repository);
  final SecureVaultRepository _repository;

  VaultItem call(String itemId, {required bool isFavorite}) =>
      _repository.setItemFavorite(itemId, isFavorite: isFavorite);
}
