import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/priority_widgets.dart';
import 'package:flutter/material.dart';

/// Row of chips letting the dashboard be narrowed down to a category, a
/// priority and/or favorites only, on top of the free-text search.
class ProjectFilterBar extends StatelessWidget {
  const ProjectFilterBar({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.selectedPriority,
    required this.onPriorityChanged,
    required this.favoritesOnly,
    required this.onFavoritesOnlyChanged,
    super.key,
  });

  final List<ProjectCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategoryChanged;
  final TaskPriority? selectedPriority;
  final ValueChanged<TaskPriority?> onPriorityChanged;
  final bool favoritesOnly;
  final ValueChanged<bool> onFavoritesOnlyChanged;

  String? get _selectedCategoryName {
    for (final category in categories) {
      if (category.id == selectedCategoryId) return category.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilterChip(
          label: Text(l10n.projectManagementFavoritesOnly),
          avatar: const Icon(Icons.star, size: 18),
          selected: favoritesOnly,
          onSelected: onFavoritesOnlyChanged,
        ),
        if (categories.isNotEmpty)
          _FilterMenuChip<String?>(
            icon: Icons.label_outline,
            label: _selectedCategoryName ?? l10n.projectManagementAllCategories,
            isActive: selectedCategoryId != null,
            items: [
              PopupMenuItem(child: Text(l10n.projectManagementAllCategories)),
              ...categories.map(
                (category) => PopupMenuItem(
                  value: category.id,
                  child: Text(category.name),
                ),
              ),
            ],
            onSelected: onCategoryChanged,
          ),
        _FilterMenuChip<TaskPriority?>(
          icon: Icons.flag_outlined,
          label:
              selectedPriority?.label(l10n) ??
              l10n.projectManagementAllPriorities,
          isActive: selectedPriority != null,
          items: [
            PopupMenuItem(child: Text(l10n.projectManagementAllPriorities)),
            ...TaskPriority.values.map(
              (priority) => PopupMenuItem(
                value: priority,
                child: Text(priority.label(l10n)),
              ),
            ),
          ],
          onSelected: onPriorityChanged,
        ),
      ],
    );
  }
}

class _FilterMenuChip<T> extends StatelessWidget {
  const _FilterMenuChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.items,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final List<PopupMenuItem<T>> items;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<T>(
      itemBuilder: (context) => items,
      onSelected: onSelected,
      child: Chip(
        avatar: Icon(
          icon,
          size: 18,
          color: isActive ? colorScheme.onPrimaryContainer : null,
        ),
        label: Text(label),
        backgroundColor: isActive ? colorScheme.primaryContainer : null,
        side: isActive ? BorderSide(color: colorScheme.primary) : null,
      ),
    );
  }
}
