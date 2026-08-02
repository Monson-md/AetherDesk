import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:flutter/material.dart';

/// Dropdown to pick the active [CodeLanguage] for the open document.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final CodeLanguage value;
  final ValueChanged<CodeLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<CodeLanguage>(
            value: value,
            icon: const Icon(Icons.expand_more),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            items: [
              for (final language in CodeLanguage.values)
                DropdownMenuItem(value: language, child: Text(language.label)),
            ],
            onChanged: (language) {
              if (language != null) onChanged(language);
            },
          ),
        ),
      ),
    );
  }
}
