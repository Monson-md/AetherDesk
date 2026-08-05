import 'package:aetherdesk/core/services/cyber_tools/cyber_tools_service_provider.dart';
import 'package:aetherdesk/features/cyber_workspace/data/repositories/cyber_workspace_repository_impl.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/repositories/cyber_workspace_repository.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/usecases/analyze_ip_usecase.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/usecases/analyze_url_usecase.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/usecases/clear_history_usecase.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/usecases/delete_history_entry_usecase.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/usecases/run_terminal_command_usecase.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/usecases/scan_ports_usecase.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/usecases/set_history_favorite_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cyberWorkspaceRepositoryProvider = Provider<CyberWorkspaceRepository>((
  ref,
) {
  return CyberWorkspaceRepositoryImpl(ref.watch(cyberToolsServiceProvider));
});

final analyzeIpUseCaseProvider = Provider<AnalyzeIpUseCase>((ref) {
  return AnalyzeIpUseCase(ref.watch(cyberWorkspaceRepositoryProvider));
});

final analyzeUrlUseCaseProvider = Provider<AnalyzeUrlUseCase>((ref) {
  return AnalyzeUrlUseCase(ref.watch(cyberWorkspaceRepositoryProvider));
});

final scanPortsUseCaseProvider = Provider<ScanPortsUseCase>((ref) {
  return ScanPortsUseCase(ref.watch(cyberWorkspaceRepositoryProvider));
});

final runTerminalCommandUseCaseProvider = Provider<RunTerminalCommandUseCase>((
  ref,
) {
  return RunTerminalCommandUseCase(ref.watch(cyberWorkspaceRepositoryProvider));
});

final setHistoryFavoriteUseCaseProvider = Provider<SetHistoryFavoriteUseCase>((
  ref,
) {
  return SetHistoryFavoriteUseCase(ref.watch(cyberWorkspaceRepositoryProvider));
});

final deleteHistoryEntryUseCaseProvider = Provider<DeleteHistoryEntryUseCase>((
  ref,
) {
  return DeleteHistoryEntryUseCase(ref.watch(cyberWorkspaceRepositoryProvider));
});

final clearHistoryUseCaseProvider = Provider<ClearHistoryUseCase>((ref) {
  return ClearHistoryUseCase(ref.watch(cyberWorkspaceRepositoryProvider));
});
