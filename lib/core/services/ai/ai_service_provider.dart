import 'package:aetherdesk/core/services/ai/ai_service.dart';
import 'package:aetherdesk/core/services/ai/simulated_ai_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single place to swap the simulated assistant for a real AI provider
/// later: change what this provider returns (or override it in a
/// `ProviderScope`) and every consumer — currently `features/ai_assistant`
/// — picks up the new implementation automatically.
final aiServiceProvider = Provider<AiService>(
  (ref) => const SimulatedAiService(),
);
