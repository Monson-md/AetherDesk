import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/features/code_editor/presentation/widgets/language_selector.dart';
import 'package:flutter/material.dart';

/// Top row of the editor: current file name and a language selector, so the
/// file's identity and active language (requirement #7) are always visible.
class CodeEditorHeader extends StatelessWidget {
  const CodeEditorHeader({
    required this.fileName,
    required this.language,
    required this.onLanguageChanged,
    super.key,
  });

  final String fileName;
  final CodeLanguage language;
  final ValueChanged<CodeLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.insert_drive_file_outlined,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(
          child: Text(
            fileName,
            style: theme.textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        LanguageSelector(value: language, onChanged: onLanguageChanged),
      ],
    );
  }
}
