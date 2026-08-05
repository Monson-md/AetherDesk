import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Free-text tag editor: a text field that turns each submitted word into a
/// deletable chip. Used by [ProjectFormDialog] and shown read-only (as
/// plain chips) on the project card/detail page.
class TagInputField extends StatefulWidget {
  const TagInputField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<String> value;
  final ValueChanged<List<String>> onChanged;

  @override
  State<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String raw) {
    final tag = raw.trim();
    if (tag.isEmpty || widget.value.contains(tag)) {
      _controller.clear();
      return;
    }
    widget.onChanged([...widget.value, tag]);
    _controller.clear();
  }

  void _remove(String tag) {
    widget.onChanged(widget.value.where((value) => value != tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: l10n.projectManagementTagsLabel,
            hintText: l10n.projectManagementTagsHint,
          ),
          onSubmitted: _submit,
        ),
        if (widget.value.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingXs,
            children: widget.value
                .map(
                  (tag) =>
                      Chip(label: Text(tag), onDeleted: () => _remove(tag)),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

/// Read-only row of tag chips shown on the project card and detail page.
class TagChipsRow extends StatelessWidget {
  const TagChipsRow({required this.tags, this.onTap, super.key});

  final List<String> tags;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: AppDimensions.spacingXs,
      runSpacing: AppDimensions.spacingXs,
      children: tags
          .map(
            (tag) => ActionChip(
              avatar: const Icon(Icons.sell_outlined, size: 14),
              label: Text(tag),
              visualDensity: VisualDensity.compact,
              onPressed: onTap == null ? null : () => onTap!(tag),
            ),
          )
          .toList(),
    );
  }
}
