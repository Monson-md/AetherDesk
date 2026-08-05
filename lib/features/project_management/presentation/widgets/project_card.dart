import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/category_widgets.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/priority_widgets.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/tag_input_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Dashboard tile summarizing one [Project]: name, category, priority,
/// task progress, due date and a quick favorite toggle.
class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.project,
    required this.category,
    required this.onTap,
    required this.onFavoriteToggle,
    super.key,
  });

  final Project project;
  final ProjectCategory? category;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      project.isFavorite ? Icons.star : Icons.star_border,
                      color: project.isFavorite ? Colors.amber : null,
                    ),
                    tooltip: project.isFavorite
                        ? l10n.projectManagementUnfavoriteTooltip
                        : l10n.projectManagementFavoriteTooltip,
                    onPressed: onFavoriteToggle,
                  ),
                ],
              ),
              if (project.description != null &&
                  project.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.spacingXs),
                  child: Text(
                    project.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: AppDimensions.spacingSm),
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingXs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  PriorityBadge(priority: project.priority),
                  if (category != null) CategoryChip(category: category!),
                  if (project.dueDate != null)
                    _InfoPill(
                      icon: Icons.event_outlined,
                      label: DateFormat.yMMMd().format(project.dueDate!),
                    ),
                ],
              ),
              if (project.tags.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingSm),
                TagChipsRow(tags: project.tags),
              ],
              if (project.tasks.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingMd),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: LinearProgressIndicator(value: project.taskProgress),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  l10n.projectManagementTasksCompletedCount(
                    project.completedTaskCount,
                    project.tasks.length,
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
