import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Row of file actions: new/open/save go through the real `FileIoService`
/// (see `CodeEditorController.openFile`/`saveFile`), plus copy, search and
/// clear.
class CodeEditorActionBar extends StatelessWidget {
  const CodeEditorActionBar({
    required this.onNewFile,
    required this.onOpen,
    required this.onSave,
    required this.onCopy,
    required this.onSearch,
    required this.onClear,
    super.key,
  });

  final VoidCallback onNewFile;
  final VoidCallback onOpen;
  final VoidCallback onSave;
  final VoidCallback onCopy;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      children: [
        OutlinedButton.icon(
          onPressed: onNewFile,
          icon: const Icon(Icons.note_add_outlined, size: 18),
          label: Text(l10n.codeEditorNewFile),
        ),
        OutlinedButton.icon(
          onPressed: onOpen,
          icon: const Icon(Icons.folder_open_outlined, size: 18),
          label: Text(l10n.codeEditorOpen),
        ),
        OutlinedButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.save_outlined, size: 18),
          label: Text(l10n.codeEditorSave),
        ),
        OutlinedButton.icon(
          onPressed: onCopy,
          icon: const Icon(Icons.copy_outlined, size: 18),
          label: Text(l10n.codeEditorCopy),
        ),
        OutlinedButton.icon(
          onPressed: onSearch,
          icon: const Icon(Icons.search, size: 18),
          label: Text(l10n.codeEditorSearch),
        ),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.delete_outline, size: 18),
          label: Text(l10n.codeEditorClear),
        ),
      ],
    );
  }
}
