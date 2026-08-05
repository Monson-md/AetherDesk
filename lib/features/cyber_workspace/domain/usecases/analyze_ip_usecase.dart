import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/repositories/cyber_workspace_repository.dart';

class AnalyzeIpUseCase {
  const AnalyzeIpUseCase(this._repository);
  final CyberWorkspaceRepository _repository;

  Future<IpAnalysisResult> call(String ip) => _repository.analyzeIp(ip);
}
