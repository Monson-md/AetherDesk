import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/cyber_history_entry.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/network_tool_type_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// One row in the history tab: which tool ran, what was queried, a result
/// summary, when it ran, a favorite toggle and a delete action.
class HistoryEntryTile extends StatelessWidget {
  const HistoryEntryTile({
    required this.entry,
    required this.onFavoriteToggle,
    required this.onDelete,
    super.key,
  });

  final CyberHistoryEntry entry;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(
          entry.toolType.icon,
          color: entry.toolType.color(theme.colorScheme),
        ),
        title: Text(entry.query, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${entry.toolType.label(l10n)} · ${entry.resultSummary}\n'
          '${DateFormat.yMMMd().add_Hm().format(entry.timestamp)}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                entry.isFavorite ? Icons.star : Icons.star_border,
                color: entry.isFavorite ? Colors.amber : null,
              ),
              onPressed: onFavoriteToggle,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
