import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/country.dart';
import 'package:aetherdesk/features/user_profile/presentation/widgets/country_widgets.dart';
import 'package:aetherdesk/features/user_profile/presentation/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfileEditResult {
  const ProfileEditResult({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.bio,
    required this.country,
    required this.avatarColorValue,
    required this.avatarIconIndex,
  });

  final String firstName;
  final String lastName;
  final String username;
  final String bio;
  final Country country;
  final int avatarColorValue;
  final int avatarIconIndex;
}

/// Edit form for the local [UserProfile]: identity fields, country and an
/// avatar built from an icon plus a color chosen from the same accent
/// palette used by the module navigation, rather than a new ad-hoc color
/// set — there is no real picture upload since this app does no real disk
/// I/O yet.
class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({
    required this.initialFirstName,
    required this.initialLastName,
    required this.initialUsername,
    required this.initialBio,
    required this.initialCountry,
    required this.initialAvatarColorValue,
    required this.initialAvatarIconIndex,
    super.key,
  });

  final String initialFirstName;
  final String initialLastName;
  final String initialUsername;
  final String initialBio;
  final Country initialCountry;
  final int initialAvatarColorValue;
  final int initialAvatarIconIndex;

  static Future<ProfileEditResult?> show(
    BuildContext context, {
    required String initialFirstName,
    required String initialLastName,
    required String initialUsername,
    required String initialBio,
    required Country initialCountry,
    required int initialAvatarColorValue,
    required int initialAvatarIconIndex,
  }) {
    return showDialog<ProfileEditResult>(
      context: context,
      builder: (_) => EditProfileDialog(
        initialFirstName: initialFirstName,
        initialLastName: initialLastName,
        initialUsername: initialUsername,
        initialBio: initialBio,
        initialCountry: initialCountry,
        initialAvatarColorValue: initialAvatarColorValue,
        initialAvatarIconIndex: initialAvatarIconIndex,
      ),
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _firstNameController = TextEditingController(
    text: widget.initialFirstName,
  );
  late final TextEditingController _lastNameController = TextEditingController(
    text: widget.initialLastName,
  );
  late final TextEditingController _usernameController = TextEditingController(
    text: widget.initialUsername,
  );
  late final TextEditingController _bioController = TextEditingController(
    text: widget.initialBio,
  );
  late Country _country = widget.initialCountry;
  late int _avatarColorValue = widget.initialAvatarColorValue;
  late int _avatarIconIndex = widget.initialAvatarIconIndex;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final paletteColors = buildNavDestinations(
      l10n,
    ).map((destination) => destination.color).toSet().toList();

    return AlertDialog(
      title: Text(l10n.userProfileEditTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.userProfileAvatarLabel,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Wrap(
              spacing: AppDimensions.spacingSm,
              runSpacing: AppDimensions.spacingSm,
              children: List.generate(kProfileAvatarIcons.length, (index) {
                final isSelected = index == _avatarIconIndex;
                return GestureDetector(
                  onTap: () => setState(() => _avatarIconIndex = index),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(_avatarColorValue),
                    child: Icon(
                      kProfileAvatarIcons[index],
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              l10n.userProfileAvatarColorLabel,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Wrap(
              spacing: AppDimensions.spacingSm,
              children: paletteColors.map((color) {
                final colorValue = color.toARGB32();
                final isSelected = colorValue == _avatarColorValue;
                return GestureDetector(
                  onTap: () => setState(() => _avatarColorValue = colorValue),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: l10n.userProfileFirstNameLabel,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: l10n.userProfileLastNameLabel,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: l10n.userProfileUsernameLabel,
                prefixText: '@',
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.userProfileBioLabel,
                hintText: l10n.userProfileBioHint,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            DropdownButtonFormField<Country>(
              initialValue: _country,
              decoration: InputDecoration(
                labelText: l10n.userProfileCountryLabel,
              ),
              items: Country.values
                  .map(
                    (country) => DropdownMenuItem(
                      value: country,
                      child: Text(country.label(l10n)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _country = value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            ProfileEditResult(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              username: _usernameController.text.trim(),
              bio: _bioController.text.trim(),
              country: _country,
              avatarColorValue: _avatarColorValue,
              avatarIconIndex: _avatarIconIndex,
            ),
          ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
