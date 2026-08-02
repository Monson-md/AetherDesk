import 'package:aetherdesk/core/auth/auth_controller.dart';
import 'package:aetherdesk/core/auth/auth_state.dart';
import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Screen shown whenever [AuthStatus] isn't `connected` (see
/// `route_guards.dart`). Not one of the 9 feature modules — this is the
/// gate the whole app sits behind, so it lives in `core/auth` next to the
/// state it renders.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _openVerificationUri(BuildContext context, String uri) async {
    final l10n = AppLocalizations.of(context)!;
    final launched = await launchUrl(
      Uri.parse(uri),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.loginOpenUrlError)));
    }
  }

  void _copyCode(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.loginCodeCopiedMessage)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveContentWrapper(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingXl),
              child: switch (authState.status) {
                AuthStatus.pending => _PendingView(
                  authState: authState,
                  onCopyCode: (code) => _copyCode(context, code),
                  onOpenVerificationUri: (uri) =>
                      _openVerificationUri(context, uri),
                ),
                AuthStatus.disconnected ||
                AuthStatus.connected => _DisconnectedView(
                  errorMessage: authState.errorMessage,
                  onConnect: () =>
                      ref.read(authControllerProvider.notifier).login(),
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DisconnectedView extends StatelessWidget {
  const _DisconnectedView({required this.onConnect, this.errorMessage});

  final VoidCallback onConnect;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.code, size: 40, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        Text(
          l10n.loginHeadline,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Text(
          l10n.loginDescription,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: AppDimensions.spacingXl),
        PrimaryButton(
          label: l10n.loginButton,
          icon: Icons.login,
          onPressed: onConnect,
        ),
      ],
    );
  }
}

class _PendingView extends StatelessWidget {
  const _PendingView({
    required this.authState,
    required this.onCopyCode,
    required this.onOpenVerificationUri,
  });

  final AuthState authState;
  final ValueChanged<String> onCopyCode;
  final ValueChanged<String> onOpenVerificationUri;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final deviceCode = authState.deviceCode;
    if (deviceCode == null) {
      return const AppLoadingIndicator();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.loginPendingTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Text(
          l10n.loginPendingDescription,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        Material(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            onTap: () => onCopyCode(deviceCode.userCode),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXl,
                vertical: AppDimensions.spacingLg,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    deviceCode.userCode,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Tooltip(
                    message: l10n.loginCopyCodeTooltip,
                    child: Icon(
                      Icons.copy_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        PrimaryButton(
          label: l10n.loginOpenGithubButton,
          icon: Icons.open_in_new,
          onPressed: () => onOpenVerificationUri(deviceCode.verificationUri),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        AppLoadingIndicator(message: l10n.loginWaitingMessage),
      ],
    );
  }
}
