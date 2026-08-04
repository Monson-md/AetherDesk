import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/presentation/providers/project_management_controller.dart';
import 'package:aetherdesk/features/project_management/presentation/widgets/category_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog listing every [ProjectCategory], letting the user add new ones or
/// delete existing ones. Consumer-aware itself (unlike the module's other
/// widgets) since it's the dedicated entry point for category CRUD rather
/// than a leaf display widget driven by a page.
class ManageCategoriesDialog extends ConsumerWidget {
  const ManageCategoriesDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(projectManagementControllerProvider.notifier);
    final categories = ref
        .watch(projectManagementControllerProvider)
        .categories;

    return AlertDialog(
      title: Text(l10n.projectManagementCategoryLabel),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (categories.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacingMd,
                ),
                child: Text(l10n.projectManagementNoCategory),
              )
            else
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: categories
                    .map(
                      (category) => CategoryChip(
                        category: category,
                        onDeleted: () => _confirmDelete(
                          context,
                          ref,
                          category.id,
                          category.name,
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: AppDimensions.spacingMd),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l10n.projectManagementNewCategory),
              onPressed: () async {
                final created = await showDialog<ProjectCategory>(
                  context: context,
                  builder: (context) => const CreateCategoryDialog(),
                );
                if (created != null) {
                  controller.createCategory(
                    name: created.name,
                    colorValue: created.colorValue,
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonConfirm),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
    String categoryName,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppAlertDialog.show(
      context,
      title: l10n.projectManagementDeleteCategoryTitle,
      message: '$categoryName — ${l10n.projectManagementDeleteCategoryMessage}',
      confirmLabel: l10n.commonConfirm,
      cancelLabel: l10n.commonCancel,
    );
    if (confirmed) {
      ref
          .read(projectManagementControllerProvider.notifier)
          .deleteCategory(categoryId);
    }
  }
}
