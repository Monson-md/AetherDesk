import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';
import 'package:aetherdesk/features/user_profile/presentation/widgets/country_widgets.dart';
import 'package:aetherdesk/features/user_profile/presentation/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Header card of the `user_profile` home page: avatar, name/username, bio,
/// country and member-since date, plus the edit entry point.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    required this.profile,
    required this.onEditPressed,
    super.key,
  });

  final UserProfile profile;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final displayName = profile.fullName.isEmpty
        ? l10n.userProfileNoName
        : profile.fullName;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileAvatar(
                  colorValue: profile.avatarColorValue,
                  iconIndex: profile.avatarIconIndex,
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: theme.textTheme.titleLarge),
                      if (profile.username.isNotEmpty)
                        Text(
                          '@${profile.username}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        profile.bio.isEmpty
                            ? l10n.userProfileNoBio
                            : profile.bio,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: l10n.userProfileEditTooltip,
                  onPressed: onEditPressed,
                ),
              ],
            ),
            const Divider(height: AppDimensions.spacingLg * 2),
            Row(
              children: [
                Icon(
                  Icons.public_outlined,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(profile.country.label(l10n)),
                const Spacer(),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.userProfileMemberSinceLabel(
                    DateFormat.yMMMd().format(profile.memberSince),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
