import 'package:aetherdesk/features/user_profile/domain/entities/country.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';
import 'package:aetherdesk/features/user_profile/presentation/providers/user_profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the local [UserProfile] and wires edits to the
/// `UserProfileRepository` usecases.
class UserProfileController extends Notifier<UserProfile> {
  @override
  UserProfile build() => ref.read(getProfileUseCaseProvider).call();

  void updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? bio,
    Country? country,
    int? avatarColorValue,
    int? avatarIconIndex,
  }) {
    state = ref
        .read(updateProfileUseCaseProvider)
        .call(
          firstName: firstName,
          lastName: lastName,
          username: username,
          bio: bio,
          country: country,
          avatarColorValue: avatarColorValue,
          avatarIconIndex: avatarIconIndex,
        );
  }
}

final userProfileControllerProvider =
    NotifierProvider<UserProfileController, UserProfile>(
      UserProfileController.new,
    );
