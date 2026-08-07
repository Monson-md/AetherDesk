import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:aetherdesk/features/user_profile/presentation/providers/cloud_account_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Optional Firebase account (email/password via `firebase_auth`) so a
/// profile can be backed up/restored across devices through Firestore
/// (see `BackupSection`) — entirely additive: the app is fully usable
/// without ever signing in, since [UserProfile] stays local-first by
/// default.
class CloudAccountSection extends ConsumerStatefulWidget {
  const CloudAccountSection({super.key});

  @override
  ConsumerState<CloudAccountSection> createState() =>
      _CloudAccountSectionState();
}

class _CloudAccountSectionState extends ConsumerState<CloudAccountSection> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _errorMessage(AppLocalizations l10n, Object error) =>
      l10n.userProfileCloudErrorGeneric('$error');

  Future<void> _submit(
    AppLocalizations l10n,
    Future<bool> Function({required String email, required String password})
    action,
  ) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userProfileCloudMissingFieldsMessage)),
      );
      return;
    }
    final ok = await action(email: email, password: password);
    if (!mounted) return;
    if (ok) {
      _passwordController.clear();
      return;
    }
    final error = ref.read(cloudAccountControllerProvider).error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_errorMessage(l10n, error ?? l10n.commonUnknownError)),
      ),
    );
  }

  Future<void> _resetPassword(AppLocalizations l10n) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userProfileCloudMissingFieldsMessage)),
      );
      return;
    }
    final ok = await ref
        .read(cloudAccountControllerProvider.notifier)
        .resetPassword(email: email);
    if (!mounted) return;
    final error = ref.read(cloudAccountControllerProvider).error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? l10n.userProfileCloudPasswordResetSentMessage
              : _errorMessage(l10n, error ?? l10n.commonUnknownError),
        ),
      ),
    );
  }

  Future<void> _signOut() =>
      ref.read(cloudAccountControllerProvider.notifier).signOut();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(cloudAuthStateProvider);
    final isBusy = ref.watch(cloudAccountControllerProvider).isLoading;

    return SettingsSectionCard(
      title: l10n.userProfileCloudTitle,
      icon: Icons.cloud_outlined,
      child: authState.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => _SignedOutForm(
          emailController: _emailController,
          passwordController: _passwordController,
          isBusy: isBusy,
          onSignIn: () => _submit(
            l10n,
            ({required email, required password}) => ref
                .read(cloudAccountControllerProvider.notifier)
                .signIn(email: email, password: password),
          ),
          onSignUp: () => _submit(
            l10n,
            ({required email, required password}) => ref
                .read(cloudAccountControllerProvider.notifier)
                .signUp(email: email, password: password),
          ),
          onForgotPassword: () => _resetPassword(l10n),
        ),
        data: (user) {
          if (user == null) {
            return _SignedOutForm(
              emailController: _emailController,
              passwordController: _passwordController,
              isBusy: isBusy,
              onSignIn: () => _submit(
                l10n,
                ({required email, required password}) => ref
                    .read(cloudAccountControllerProvider.notifier)
                    .signIn(email: email, password: password),
              ),
              onSignUp: () => _submit(
                l10n,
                ({required email, required password}) => ref
                    .read(cloudAccountControllerProvider.notifier)
                    .signUp(email: email, password: password),
              ),
              onForgotPassword: () => _resetPassword(l10n),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.userProfileCloudSignedInAs(user.email ?? user.uid),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: isBusy ? null : _signOut,
                  icon: const Icon(Icons.logout, size: 18),
                  label: Text(l10n.userProfileCloudSignOutButton),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SignedOutForm extends StatelessWidget {
  const _SignedOutForm({
    required this.emailController,
    required this.passwordController,
    required this.isBusy,
    required this.onSignIn,
    required this.onSignUp,
    required this.onForgotPassword,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isBusy;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.userProfileCloudDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        AppTextField(
          label: l10n.userProfileCloudEmailLabel,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        AppTextField(
          label: l10n.userProfileCloudPasswordLabel,
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: [
            PrimaryButton(
              label: l10n.userProfileCloudSignInButton,
              isLoading: isBusy,
              onPressed: isBusy ? null : onSignIn,
            ),
            OutlinedButton(
              onPressed: isBusy ? null : onSignUp,
              child: Text(l10n.userProfileCloudSignUpButton),
            ),
          ],
        ),
        TextButton(
          onPressed: isBusy ? null : onForgotPassword,
          child: Text(l10n.userProfileCloudForgotPasswordButton),
        ),
      ],
    );
  }
}
