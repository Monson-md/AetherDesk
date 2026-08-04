import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class CreateSecureNoteUseCase {
  const CreateSecureNoteUseCase(this._repository);
  final SecureVaultRepository _repository;

  SecureNoteItem call({
    required String title,
    required String content,
    String? folderId,
  }) => _repository.createSecureNote(
    title: title,
    content: content,
    folderId: folderId,
  );
}
