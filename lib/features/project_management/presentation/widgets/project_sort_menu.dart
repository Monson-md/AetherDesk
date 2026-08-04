import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_sort_option.dart';
import 'package:flutter/material.dart';

/// Maps [ProjectSortOption] to a localized label, kept in the presentation
/// layer since `domain/entities/` must stay Flutter-free.
extension ProjectSortOptionPresentation on ProjectSortOption {
  String label(AppLocalizations l10n) => switch (this) {
    ProjectSortOption.name => l10n.projectManagementSortName,
    ProjectSortOption.dueDate => l10n.projectManagementSortDueDate,
    ProjectSortOption.priority => l10n.projectManagementSortPriority,
    ProjectSortOption.createdAt => l10n.projectManagementSortCreatedAt,
  };
}

/// Dropdown for picking how the dashboard orders its project list.
class ProjectSortMenu extends StatelessWidget {
  const ProjectSortMenu({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ProjectSortOption value;
  final ValueChanged<ProjectSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonHideUnderline(
      child: DropdownButton<ProjectSortOption>(
        value: value,
        icon: const Icon(Icons.sort),
        items: ProjectSortOption.values
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(
                  '${l10n.projectManagementSortLabel}: ${option.label(l10n)}',
                ),
              ),
            )
            .toList(),
        onChanged: (option) {
          if (option != null) onChanged(option);
        },
      ),
    );
  }
}
