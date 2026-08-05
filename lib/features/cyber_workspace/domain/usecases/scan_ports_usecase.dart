import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/repositories/cyber_workspace_repository.dart';

class ScanPortsUseCase {
  const ScanPortsUseCase(this._repository);
  final CyberWorkspaceRepository _repository;

  Future<PortScanResult> call(String host, List<int> ports) =>
      _repository.scanPorts(host, ports);
}
