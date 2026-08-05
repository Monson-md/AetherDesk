import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/url_analysis_result.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/risk_score_badge.dart';
import 'package:flutter/material.dart';

/// Card with a URL field, a submit button and the last [UrlAnalysisResult]
/// — see [IpAnalysisSection]'s doc comment for the shared shape.
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
              Row(
                children: [
                  Text(
                    '${l10n.cyberWorkspaceCategoryLabel}: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(result.category, style: theme.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Row(
                children: [
                  RiskScoreBadge(score: result.riskScore),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Icon(
                    result.isSafe
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    size: 16,
                    color: result.isSafe
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  const SizedBox(width: AppDimensions.spacingXs),
                  Text(
                    result.isSafe
                        ? l10n.cyberWorkspaceSafeLabel
                        : l10n.cyberWorkspaceUnsafeLabel,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
