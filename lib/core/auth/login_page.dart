import 'package:aetherdesk/core/auth/auth_controller.dart';
import 'package:aetherdesk/core/auth/auth_state.dart';
import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/github/github_auth_log.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                switch (authState.status) {
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
                const SizedBox(height: AppDimensions.spacingXl),
                const _DiagnosticsSection(),
              ],
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
        const SizedBox(height: AppDimensions.spacingMd),
        const _PersonalAccessTokenSection(),
      ],
    );
  }
}

/// Fallback sign-in for when the device flow itself can't be reached: a
/// collapsed text button that reveals a token field on tap.
class _PersonalAccessTokenSection extends ConsumerStatefulWidget {
  const _PersonalAccessTokenSection();

  @override
  ConsumerState<_PersonalAccessTokenSection> createState() =>
      _PersonalAccessTokenSectionState();
}

class _PersonalAccessTokenSectionState
    extends ConsumerState<_PersonalAccessTokenSection> {
  bool _expanded = false;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_expanded) {
      return TextButton(
        onPressed: () => setState(() => _expanded = true),
        child: Text(l10n.loginPatButton),
      );
    }

    return Column(
      children: [
        TextField(
          controller: _controller,
          obscureText: true,
          decoration: InputDecoration(hintText: l10n.loginPatFieldHint),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        PrimaryButton(
          label: l10n.loginPatSubmitButton,
          onPressed: () {
            final token = _controller.text.trim();
            if (token.isEmpty) return;
            ref
                .read(authControllerProvider.notifier)
                .loginWithPersonalAccessToken(token);
          },
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

/// Collapsible request/response log (see `github_auth_log.dart`) — the only
/// way to diagnose the device flow on a phone with no PC/adb attached.
/// Stays mounted regardless of [AuthStatus], so it's still there after an
/// error sends the screen back to the disconnected state.
class _DiagnosticsSection extends ConsumerWidget {
  const _DiagnosticsSection();

  Future<void> _copyLogs(
    BuildContext context,
    WidgetRef ref,
    DateFormat formatter,
    AppLocalizations l10n,
  ) async {
    final entries = ref.read(githubAuthLogProvider);
    final text = entries
        .map(
          (e) =>
              '${formatter.format(e.timestamp)}  ${e.label} -> HTTP ${e.statusCode}\n${e.body}',
        )
        .join('\n\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginDiagnosticsCopiedMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final entries = ref.watch(githubAuthLogProvider);
    final formatter = DateFormat.Hms();
    final monospaceStyle = theme.textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
    );

    return ExpansionTile(
      title: Text(l10n.loginDiagnosticsTitle),
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingSm,
      ),
      children: [
        if (entries.isEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.loginDiagnosticsEmpty,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          )
        else ...[
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${formatter.format(entry.timestamp)}  ${entry.label} -> HTTP ${entry.statusCode}\n${entry.body}',
                  style: monospaceStyle,
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _copyLogs(context, ref, formatter, l10n),
              icon: const Icon(Icons.copy_outlined, size: 16),
              label: Text(l10n.loginDiagnosticsCopyButton),
            ),
          ),
        ],
      ],
    );
  }
}
