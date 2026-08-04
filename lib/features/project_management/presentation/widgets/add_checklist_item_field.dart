import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Inline text field + submit action for appending a new checklist item.
/// Owns its own [TextEditingController] so parents (task tiles rendered in
/// a list) don't need to become stateful just for this.
class AddChecklistItemField extends StatefulWidget {
  const AddChecklistItemField({required this.onSubmit, super.key});

  final ValueChanged<String> onSubmit;

  @override
  State<AddChecklistItemField> createState() => _AddChecklistItemFieldState();
}

class _AddChecklistItemFieldState extends State<AddChecklistItemField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final label = _controller.text.trim();
    if (label.isEmpty) return;
    widget.onSubmit(label);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: l10n.projectManagementAddChecklistItemHint,
              isDense: true,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        IconButton(icon: const Icon(Icons.add), onPressed: _submit),
      ],
    );
  }
}
