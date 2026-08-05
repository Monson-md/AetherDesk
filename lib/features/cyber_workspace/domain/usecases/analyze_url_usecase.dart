import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/repositories/cyber_workspace_repository.dart';

class AnalyzeUrlUseCase {
  const AnalyzeUrlUseCase(this._repository);
  final CyberWorkspaceRepository _repository;

  Future<UrlAnalysisResult> call(String url) => _repository.analyzeUrl(url);
}
