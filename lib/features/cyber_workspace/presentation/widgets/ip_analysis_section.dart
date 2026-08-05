import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/ip_analysis_result.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/risk_score_badge.dart';
import 'package:flutter/material.dart';

/// Card with an IP address field, a submit button and the last
/// [IpAnalysisResult] — a self-contained section of the "Network Tools"
/// tab, mirroring [UrlAnalysisSection]/`PortScannerSection`'s shape.
class IpAnalysisSection extends StatefulWidget {
  const IpAnalysisSection({
    required this.isRunning,
    required this.result,
    required this.onAnalyze,
    super.key,
  });

  final bool isRunning;
  final IpAnalysisResult? result;
  final ValueChanged<String> onAnalyze;

  @override
  State<IpAnalysisSection> createState() => _IpAnalysisSectionState();
}

class _IpAnalysisSectionState extends State<IpAnalysisSection> {
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
                Icon(
                  Icons.travel_explore_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceToolIpAnalysis,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.cyberWorkspaceIpAddressLabel,
                    controller: _controller,
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
              _ResultRow(
                label: l10n.cyberWorkspaceCountryLabel,
                value: result.country,
              ),
              _ResultRow(label: l10n.cyberWorkspaceIspLabel, value: result.isp),
              const SizedBox(height: AppDimensions.spacingXs),
              Row(
                children: [
                  RiskScoreBadge(score: result.riskScore),
                  if (result.isSuspicious) ...[
                    const SizedBox(width: AppDimensions.spacingSm),
                    Icon(
                      Icons.warning_amber_outlined,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: AppDimensions.spacingXs),
                    Text(
                      l10n.cyberWorkspaceSuspiciousLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
