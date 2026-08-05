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

/// Home screen of the `code_editor` module: a premium code editing surface
/// with real file open/save (`FileIoService`) and real in-document search
/// (`CodeFieldState`). See `SyntaxHighlighter`/`syntaxHighlighterProvider`
/// for the seam where a real editing engine plugs in later.
class CodeEditorHomePage extends ConsumerStatefulWidget {
  const CodeEditorHomePage({super.key});

  @override
  ConsumerState<CodeEditorHomePage> createState() => _CodeEditorHomePageState();
}

class _CodeEditorHomePageState extends ConsumerState<CodeEditorHomePage> {
  final _codeFieldKey = GlobalKey<CodeFieldState>();
  final _searchController = TextEditingController();
  bool _isSearchOpen = false;
  bool _isBusy = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openFile(CodeEditorController controller) async {
    setState(() => _isBusy = true);
    final opened = await controller.openFile();
    if (!mounted) return;
    setState(() => _isBusy = false);
    if (opened) {
      final fileName = ref.read(codeEditorControllerProvider).fileName;
      _showMessage(
        AppLocalizations.of(context)!.codeEditorFileOpenedMessage(fileName),
      );
    }
  }

  Future<void> _saveFile(CodeEditorController controller) async {
    setState(() => _isBusy = true);
    final saved = await controller.saveFile();
    if (!mounted) return;
    setState(() => _isBusy = false);
    if (saved) {
      final fileName = ref.read(codeEditorControllerProvider).fileName;
      _showMessage(
        AppLocalizations.of(context)!.codeEditorFileSavedMessage(fileName),
      );
    }
  }

  void _toggleSearch() {
    setState(() => _isSearchOpen = !_isSearchOpen);
    if (!_isSearchOpen) {
      _searchController.clear();
      _codeFieldKey.currentState?.updateSearch('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.codeEditor);
    final document = ref.watch(codeEditorControllerProvider);
    final controller = ref.read(codeEditorControllerProvider.notifier);
    final fieldState = _codeFieldKey.currentState;

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
                onOpen: _isBusy ? () {} : () => _openFile(controller),
                onSave: _isBusy ? () {} : () => _saveFile(controller),
                onSearch: _toggleSearch,
                onCopy: () async {
                  await Clipboard.setData(
                    ClipboardData(text: document.content),
                  );
                  if (context.mounted) {
                    _showMessage(l10n.codeEditorCopiedMessage);
                  }
                },
                onClear: controller.clearContent,
              ),
              if (_isSearchOpen) ...[
                const SizedBox(height: AppDimensions.spacingSm),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMd,
                      vertical: AppDimensions.spacingXs,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: l10n.codeEditorSearchHint,
                            ),
                            onChanged: (query) => setState(
                              () => _codeFieldKey.currentState?.updateSearch(
                                query,
                              ),
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacingSm,
                            ),
                            child: Text(
                              (fieldState?.matchCount ?? 0) == 0
                                  ? l10n.codeEditorSearchNoMatches
                                  : '${(fieldState!.currentMatchIndex) + 1}/${fieldState.matchCount}',
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_up),
                          onPressed: () => setState(
                            () => _codeFieldKey.currentState?.previousMatch(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onPressed: () => setState(
                            () => _codeFieldKey.currentState?.nextMatch(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _toggleSearch,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.spacingMd),
              Expanded(
                child: CodeField(
                  key: _codeFieldKey,
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
