import 'package:aetherdesk/features/cyber_workspace/domain/entities/network_tool_type.dart';

/// One past run of a tool: which [toolType] was used, what [query] was
/// submitted, a short human-readable [resultSummary], when it ran, and
/// whether the user starred it for quick access later.
class CyberHistoryEntry {
  const CyberHistoryEntry({
    required this.id,
    required this.toolType,
    required this.query,
    required this.resultSummary,
    required this.timestamp,
    required this.isFavorite,
  });

  final String id;
  final NetworkToolType toolType;
  final String query;
  final String resultSummary;
  final DateTime timestamp;
  final bool isFavorite;

  CyberHistoryEntry copyWith({bool? isFavorite}) {
    return CyberHistoryEntry(
      id: id,
      toolType: toolType,
      query: query,
      resultSummary: resultSummary,
      timestamp: timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
