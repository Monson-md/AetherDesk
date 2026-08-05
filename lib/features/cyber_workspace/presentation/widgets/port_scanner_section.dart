import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/cyber_tools/models/port_scan_result.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:flutter/material.dart';

const _commonPorts = [21, 22, 23, 25, 53, 80, 110, 143, 443, 3306, 3389, 8080];

/// Card with a host field, a toggleable list of common ports, a scan
/// button and the last [PortScanResult] — see `IpAnalysisSection`'s doc
/// comment for the shared shape.
class PortScannerSection extends StatefulWidget {
  const PortScannerSection({
    required this.isRunning,
    required this.result,
    required this.onScan,
    super.key,
  });

  final bool isRunning;
  final PortScanResult? result;
  final void Function(String host, List<int> ports) onScan;

  @override
  State<PortScannerSection> createState() => _PortScannerSectionState();
}

class _PortScannerSectionState extends State<PortScannerSection> {
  final _hostController = TextEditingController();
  Set<int> _selectedPorts = {21, 22, 80, 443, 3389};

  @override
  void dispose() {
    _hostController.dispose();
    super.dispose();
  }

  void _togglePort(int port, bool selected) {
    setState(() {
      _selectedPorts = selected
          ? {..._selectedPorts, port}
          : (_selectedPorts.toSet()..remove(port));
    });
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
                  Icons.settings_ethernet_outlined,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.cyberWorkspaceToolPortScan,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            AppTextField(
              label: l10n.cyberWorkspaceHostLabel,
              controller: _hostController,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Wrap(
              spacing: AppDimensions.spacingXs,
              runSpacing: AppDimensions.spacingXs,
              children: _commonPorts
                  .map(
                    (port) => FilterChip(
                      label: Text('$port'),
                      selected: _selectedPorts.contains(port),
                      onSelected: (selected) => _togglePort(port, selected),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Align(
              alignment: Alignment.centerRight,
              child: PrimaryButton(
                label: l10n.cyberWorkspaceScanAction,
                isLoading: widget.isRunning,
                onPressed: _selectedPorts.isEmpty
                    ? null
                    : () => widget.onScan(
                        _hostController.text,
                        _selectedPorts.toList()..sort(),
                      ),
              ),
            ),
            if (result != null) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              const Divider(),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                l10n.cyberWorkspacePortsOpenCount(
                  result.openCount,
                  result.entries.length,
                ),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Wrap(
                spacing: AppDimensions.spacingXs,
                runSpacing: AppDimensions.spacingXs,
                children: result.entries
                    .map(
                      (entry) => Chip(
                        avatar: Icon(
                          entry.isOpen
                              ? Icons.lock_open_outlined
                              : Icons.lock_outline,
                          size: 16,
                          color: entry.isOpen
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                        ),
                        label: Text('${entry.port} · ${entry.service}'),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
