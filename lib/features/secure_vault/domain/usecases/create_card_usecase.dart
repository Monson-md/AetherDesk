import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class CreateCardUseCase {
  const CreateCardUseCase(this._repository);
  final SecureVaultRepository _repository;

  Future<CardItem> call({
    required String title,
    required String cardholderName,
    required String cardNumber,
    required String expiry,
    String? cvv,
    String? folderId,
  }) => _repository.createCard(
    title: title,
    cardholderName: cardholderName,
    cardNumber: cardNumber,
    expiry: expiry,
    cvv: cvv,
    folderId: folderId,
  );
}
