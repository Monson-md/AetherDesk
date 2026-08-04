import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Button that opens a date picker and shows the picked [value], with a
/// clear action once a date is set. Shared by the project and task forms.
class DueDateField extends StatelessWidget {
  const DueDateField({required this.value, required this.onChanged, super.key});

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(
              value == null
                  ? l10n.projectManagementNoDueDate
                  : DateFormat.yMMMd().format(value!),
            ),
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: theme.colorScheme.onSurface,
            ),
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: value ?? now,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 10),
              );
              if (picked != null) onChanged(picked);
            },
          ),
        ),
        if (value != null)
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.projectManagementClearDate,
            onPressed: () => onChanged(null),
          ),
        const SizedBox(width: AppDimensions.spacingXs),
      ],
    );
  }
}
