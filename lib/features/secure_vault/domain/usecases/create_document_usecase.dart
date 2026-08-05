import 'package:aetherdesk/features/secure_vault/domain/entities/vault_item.dart';
import 'package:aetherdesk/features/secure_vault/domain/repositories/secure_vault_repository.dart';

class CreateDocumentUseCase {
  const CreateDocumentUseCase(this._repository);
  final SecureVaultRepository _repository;

  Future<DocumentItem> call({
    required String title,
    required String fileName,
    String? notes,
    String? folderId,
  }) => _repository.createDocument(
    title: title,
    fileName: fileName,
    notes: notes,
    folderId: folderId,
  );
}
