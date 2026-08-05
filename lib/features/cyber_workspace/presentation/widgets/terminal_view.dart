import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Simulated shell: a monospace scrollback of prior commands/output plus
/// an input line. No real process is spawned — see
/// `SimulatedCyberToolsService.runCommand`'s doc comment.
class TerminalView extends StatefulWidget {
  const TerminalView({required this.lines, required this.onSubmit, super.key});

  final List<String> lines;
  final ValueChanged<String> onSubmit;

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant TerminalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lines.length != widget.lines.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text;
    if (value.trim().isEmpty) return;
    widget.onSubmit(value);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    const monospace = TextStyle(fontFamily: 'monospace', fontSize: 13);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 320,
              padding: const EdgeInsets.all(AppDimensions.spacingSm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: widget.lines.isEmpty
                  ? Text(
                      l10n.cyberWorkspaceTerminalHint,
                      style: monospace.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: widget.lines.length,
                      itemBuilder: (context, index) =>
                          Text(widget.lines[index], style: monospace),
                    ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Row(
              children: [
                const Text('>', style: monospace),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: monospace,
                    decoration: InputDecoration(
                      hintText: l10n.cyberWorkspaceTerminalInputHint,
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_outlined),
                  onPressed: _submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
