import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:flutter/material.dart';

/// A bounded, curated set of colors a user can assign to a
/// [ProjectCategory] — categories need several simultaneous, mutually
/// distinguishable colors, unlike a module's single accent color from
/// `nav_destinations.dart`.
const List<Color> categoryColorPalette = [
  Color(0xFFEF4444),
  Color(0xFFF97316),
  Color(0xFFF59E0B),
  Color(0xFF22C55E),
  Color(0xFF14B8A6),
  Color(0xFF3B82F6),
  Color(0xFF8B5CF6),
  Color(0xFFEC4899),
];

/// Small colored chip showing a category's name, with an optional delete
/// action.
class CategoryChip extends StatelessWidget {
  const CategoryChip({required this.category, this.onDeleted, super.key});

  final ProjectCategory category;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 6),
      label: Text(category.name),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      onDeleted: onDeleted,
    );
  }
}

/// Dropdown for picking an optional [ProjectCategory], with a button to
/// create a new one inline.
class CategoryPickerField extends StatelessWidget {
  const CategoryPickerField({
    required this.categories,
    required this.value,
    required this.onChanged,
    required this.onCreateCategory,
    super.key,
  });

  final List<ProjectCategory> categories;
  final String? value;
  final ValueChanged<String?> onChanged;
  final VoidCallback onCreateCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String?>(
            initialValue: value,
            decoration: InputDecoration(
              labelText: l10n.projectManagementCategoryLabel,
            ),
            items: [
              DropdownMenuItem(child: Text(l10n.projectManagementNoCategory)),
              ...categories.map(
                (category) => DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                ),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        IconButton(
          onPressed: onCreateCategory,
          icon: const Icon(Icons.add_circle_outline),
          tooltip: l10n.projectManagementNewCategory,
        ),
      ],
    );
  }
}

/// Dialog to create a new [ProjectCategory]: a name field plus a swatch
/// picker over [categoryColorPalette].
class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({super.key});

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  final _nameController = TextEditingController();
  Color _selectedColor = categoryColorPalette.first;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_handleNameChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleNameChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.projectManagementNewCategory),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            label: l10n.projectManagementCategoryNameHint,
            controller: _nameController,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: categoryColorPalette.map((color) {
              final isSelected = color.toARGB32() == _selectedColor.toARGB32();
              return InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                onTap: () => setState(() => _selectedColor = color),
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: isSelected ? 16 : 14,
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _nameController.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  ProjectCategory(
                    id: '',
                    name: _nameController.text.trim(),
                    colorValue: _selectedColor.toARGB32(),
                  ),
                ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
