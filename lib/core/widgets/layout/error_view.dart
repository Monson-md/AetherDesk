import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/error/failure.dart';
import 'package:aetherdesk/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

/// Renders any [Failure] with an optional retry action. Feature modules
/// should use this instead of building ad-hoc error UI, so failures always
/// look the same regardless of which module raised them.
class ErrorView extends StatelessWidget {
  const ErrorView({required this.failure, this.onRetry, super.key});

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(failure.message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacingLg),
              PrimaryButton(label: 'Retry', onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
