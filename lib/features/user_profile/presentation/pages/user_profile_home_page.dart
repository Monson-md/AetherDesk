import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/app_info_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/appearance_section.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:aetherdesk/features/user_profile/presentation/providers/user_profile_controller.dart';
import 'package:aetherdesk/features/user_profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:aetherdesk/features/user_profile/presentation/widgets/profile_header_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `user_profile` module: identity (name, username,
/// bio, country, avatar), the cross-cutting language/theme preferences also
/// surfaced here for convenience, and static app info — all local, no
/// backend. See `UserProfileRepository`'s doc comment for the Firestore
/// swap point this is architected for.
class UserProfileHomePage extends ConsumerWidget {
  const UserProfileHomePage({super.key});

  Future<void> _editProfile(BuildContext context, WidgetRef ref) async {
    final profile = ref.read(userProfileControllerProvider);
    final result = await EditProfileDialog.show(
      context,
      initialFirstName: profile.firstName,
      initialLastName: profile.lastName,
      initialUsername: profile.username,
      initialBio: profile.bio,
      initialCountry: profile.country,
      initialAvatarColorValue: profile.avatarColorValue,
      initialAvatarIconIndex: profile.avatarIconIndex,
    );
    if (result == null) return;
    ref
        .read(userProfileControllerProvider.notifier)
        .updateProfile(
          firstName: result.firstName,
          lastName: result.lastName,
          username: result.username,
          bio: result.bio,
          country: result.country,
          avatarColorValue: result.avatarColorValue,
          avatarIconIndex: result.avatarIconIndex,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.userProfile);
    final profile = ref.watch(userProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(destination.label)),
      body: ResponsiveContentWrapper(
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          children: [
            ProfileHeaderCard(
              profile: profile,
              onEditPressed: () => _editProfile(context, ref),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            const LanguageSection(),
            const SizedBox(height: AppDimensions.spacingMd),
            const ThemeSection(),
            const SizedBox(height: AppDimensions.spacingMd),
            const AppearanceSection(),
            const SizedBox(height: AppDimensions.spacingMd),
            SettingsSectionCard(
              title: l10n.userProfilePrivacyTitle,
              icon: Icons.privacy_tip_outlined,
              child: Text(
                l10n.userProfileLocalOnlyNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            const AppInfoSection(),
          ],
        ),
      ),
    );
  }
}
