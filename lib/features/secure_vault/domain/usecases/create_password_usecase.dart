import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class CreatePasswordUseCase {
  const CreatePasswordUseCase(this._repository);
  final SecureVaultRepository _repository;

  PasswordItem call({
    required String title,
    required String username,
    required String password,
    String? url,
    String? folderId,
  }) => _repository.createPassword(
    title: title,
    username: username,
    password: password,
    url: url,
    folderId: folderId,
  );
}
