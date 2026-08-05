import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_management_view_mode.dart';
import 'package:flutter/material.dart';

/// Segmented control letting the dashboard switch between its list, Kanban
/// and calendar presentations of the same filtered project collection.
class ViewModeToggle extends StatelessWidget {
  const ViewModeToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ProjectManagementViewMode value;
  final ValueChanged<ProjectManagementViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SegmentedButton<ProjectManagementViewMode>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: ProjectManagementViewMode.list,
          icon: const Icon(Icons.view_list_outlined),
          tooltip: l10n.projectManagementViewList,
        ),
        ButtonSegment(
          value: ProjectManagementViewMode.kanban,
          icon: const Icon(Icons.view_column_outlined),
          tooltip: l10n.projectManagementViewKanban,
        ),
        ButtonSegment(
          value: ProjectManagementViewMode.calendar,
          icon: const Icon(Icons.calendar_month_outlined),
          tooltip: l10n.projectManagementViewCalendar,
        ),
      ],
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
