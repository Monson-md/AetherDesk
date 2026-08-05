import 'package:aetherdesk/core/services/cyber_tools/cyber_tools_service.dart';
import 'package:aetherdesk/core/services/cyber_tools/simulated_cyber_tools_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cyberToolsServiceProvider = Provider<CyberToolsService>((ref) {
  return const SimulatedCyberToolsService();
});
