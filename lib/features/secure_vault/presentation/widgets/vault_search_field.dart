import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Search box for the vault dashboard. Owns its own [TextEditingController]
/// so the page doesn't need to become stateful just for this.
class VaultSearchField extends StatefulWidget {
  const VaultSearchField({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<VaultSearchField> createState() => _VaultSearchFieldState();
}

class _VaultSearchFieldState extends State<VaultSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  )..addListener(_handleTextChanged);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: l10n.secureVaultSearchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                  setState(() {});
                },
              ),
        isDense: true,
      ),
    );
  }
}
