import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:flutter/material.dart';

/// Card with a URL field, a submit button and the last real
/// [UrlAnalysisResult] — see [IpAnalysisSection]'s doc comment for the
/// shared shape.
class UrlAnalysisSection extends StatefulWidget {
  const UrlAnalysisSection({
    required this.isRunning,
    required this.result,
    required this.onAnalyze,
    super.key,
  });

  final bool isRunning;
  final UrlAnalysisResult? result;
  final ValueChanged<String> onAnalyze;

  @override
  State<UrlAnalysisSection> createState() => _UrlAnalysisSectionState();
}

class _UrlAnalysisSectionState extends State<UrlAnalysisSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final result = widget.result;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.link_outlined, color: theme.colorScheme.tertiary),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceToolUrlAnalysis,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.cyberWorkspaceUrlLabel,
                    controller: _controller,
                    keyboardType: TextInputType.url,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                PrimaryButton(
                  label: l10n.cyberWorkspaceAnalyzeAction,
                  isLoading: widget.isRunning,
                  onPressed: () => widget.onAnalyze(_controller.text),
                ),
              ],
            ),
            if (result != null) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              const Divider(),
              const SizedBox(height: AppDimensions.spacingSm),
              if (!result.isValid)
                Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: AppDimensions.spacingXs),
                    Text(
                      l10n.cyberWorkspaceUrlInvalidMessage,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                )
              else ...[
                Row(
                  children: [
                    Text(
                      '${l10n.cyberWorkspaceSchemeLabel}: ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(result.scheme, style: theme.textTheme.bodyMedium),
                    const SizedBox(width: AppDimensions.spacingMd),
                    Text(
                      '${l10n.cyberWorkspaceHostLabel}: ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        result.host,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Row(
                  children: [
                    Icon(
                      result.isReachable
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      size: 16,
                      color: result.isReachable
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                    ),
                    const SizedBox(width: AppDimensions.spacingXs),
                    Text(
                      result.isReachable
                          ? l10n.cyberWorkspaceReachableLabel
                          : l10n.cyberWorkspaceUnreachableLabel,
                      style: theme.textTheme.bodySmall,
                    ),
                    if (result.responseTime != null) ...[
                      const SizedBox(width: AppDimensions.spacingSm),
                      Text(
                        l10n.cyberWorkspaceResponseTimeLabel(
                          result.responseTime!.inMilliseconds,
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
