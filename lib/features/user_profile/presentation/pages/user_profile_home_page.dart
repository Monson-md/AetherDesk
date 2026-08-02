import 'package:aetherdesk/core/auth/auth_controller.dart';
import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/user_profile/presentation/providers/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `user_profile` module: the signed-in GitHub user
/// (`GET /user`) and a sign-out action. The only module this task touches —
/// every other module keeps its `ModulePlaceholderPage`.
class UserProfileHomePage extends ConsumerWidget {
  const UserProfileHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.userProfile);
    final profileState = ref.watch(userProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(destination.label)),
      body: ResponsiveContentWrapper(
        child: Builder(
          builder: (context) {
            if (profileState.isLoading) {
              return const AppLoadingIndicator();
            }
            final failure = profileState.failure;
            if (failure != null) {
              return ErrorView(
                failure: failure,
                onRetry: () => ref
                    .read(userProfileControllerProvider.notifier)
                    .loadProfile(),
              );
            }
            final profile = profileState.profile!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingXl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(profile.avatarUrl),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),
                    Text(
                      profile.name ?? profile.login,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      '@${profile.login}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    Text(
                      l10n.profilePublicReposCount(profile.publicRepos),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppDimensions.spacingXl),
                    PrimaryButton(
                      label: l10n.profileLogoutButton,
                      icon: Icons.logout,
                      onPressed: () =>
                          ref.read(authControllerProvider.notifier).logout(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
