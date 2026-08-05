import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/entities/network_tool_type.dart';
import 'package:aetherdesk/features/cyber_workspace/presentation/widgets/network_tool_type_widgets.dart';
import 'package:flutter/material.dart';

/// Row of chips narrowing the history list down to favorites and/or a
/// single tool type.
class HistoryFilterBar extends StatelessWidget {
  const HistoryFilterBar({
    required this.favoritesOnly,
    required this.onFavoritesOnlyChanged,
    required this.selectedToolType,
    required this.onToolTypeChanged,
    super.key,
  });

  final bool favoritesOnly;
  final ValueChanged<bool> onFavoritesOnlyChanged;
  final NetworkToolType? selectedToolType;
  final ValueChanged<NetworkToolType?> onToolTypeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilterChip(
          label: Text(l10n.cyberWorkspaceFavoritesOnly),
          avatar: const Icon(Icons.star, size: 18),
          selected: favoritesOnly,
          onSelected: onFavoritesOnlyChanged,
        ),
        ChoiceChip(
          label: Text(l10n.cyberWorkspaceAllTools),
          selected: selectedToolType == null,
          onSelected: (_) => onToolTypeChanged(null),
        ),
        ...NetworkToolType.values.map(
          (type) => ChoiceChip(
            label: Text(type.label(l10n)),
            selected: selectedToolType == type,
            onSelected: (_) => onToolTypeChanged(type),
          ),
        ),
      ],
    );
  }
}
