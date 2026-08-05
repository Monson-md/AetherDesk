import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class CreateApiKeyUseCase {
  const CreateApiKeyUseCase(this._repository);
  final SecureVaultRepository _repository;

  Future<ApiKeyItem> call({
    required String title,
    required String service,
    required String apiKey,
    String? folderId,
  }) => _repository.createApiKey(
    title: title,
    service: service,
    apiKey: apiKey,
    folderId: folderId,
  );
}
