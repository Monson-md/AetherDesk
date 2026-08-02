import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/widgets/layout/responsive_content_wrapper.dart';
import 'package:aetherdesk/features/code_editor/presentation/providers/code_editor_controller.dart';
import 'package:aetherdesk/features/code_editor/presentation/widgets/code_editor_action_bar.dart';
import 'package:aetherdesk/features/code_editor/presentation/widgets/code_editor_header.dart';
import 'package:aetherdesk/features/code_editor/presentation/widgets/code_editor_stats_bar.dart';
import 'package:aetherdesk/features/code_editor/presentation/widgets/code_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `code_editor` module: a premium, offline code editing
/// surface. See `SyntaxHighlighter` / `syntaxHighlighterProvider` for the
/// seam where a real editing engine plugs in later without touching
/// anything in this file.
class CodeEditorHomePage extends ConsumerWidget {
  const CodeEditorHomePage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.codeEditor);
    final document = ref.watch(codeEditorControllerProvider);
    final controller = ref.read(codeEditorControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(destination.label)),
      body: ResponsiveContentWrapper(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CodeEditorHeader(
                fileName: document.fileName,
                language: document.language,
                onLanguageChanged: controller.changeLanguage,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              CodeEditorActionBar(
                onNewFile: controller.newFile,
                onOpen: () =>
                    _showMessage(context, l10n.codeEditorOpenPlaceholder),
                onSave: () =>
                    _showMessage(context, l10n.codeEditorSavePlaceholder),
                onCopy: () async {
                  await Clipboard.setData(
                    ClipboardData(text: document.content),
                  );
                  if (context.mounted) {
                    _showMessage(context, l10n.codeEditorCopiedMessage);
                  }
                },
                onClear: controller.clearContent,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Expanded(
                child: CodeField(
                  content: document.content,
                  language: document.language,
                  onChanged: controller.updateContent,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              CodeEditorStatsBar(content: document.content),
            ],
          ),
        ),
      ),
    );
  }
}
