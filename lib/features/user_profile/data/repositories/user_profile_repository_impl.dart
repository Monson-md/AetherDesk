import 'package:aetherdesk/features/user_profile/domain/entities/country.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';
import 'package:aetherdesk/features/user_profile/domain/repositories/user_profile_repository.dart';

/// In-memory [UserProfileRepository]: holds the single local [UserProfile]
/// for the lifetime of the app session. See the interface's doc comment for
/// the Firestore swap point this is meant to be replaced by later.
class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfile _profile = UserProfile.initial();

  @override
  UserProfile getProfile() => _profile;

  @override
  UserProfile updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? bio,
    Country? country,
    int? avatarColorValue,
    int? avatarIconIndex,
    String? avatarPhotoPath,
    bool clearAvatarPhotoPath = false,
  }) {
    _profile = _profile.copyWith(
      firstName: firstName,
      lastName: lastName,
      username: username,
      bio: bio,
      country: country,
      avatarColorValue: avatarColorValue,
      avatarIconIndex: avatarIconIndex,
      avatarPhotoPath: avatarPhotoPath,
      clearAvatarPhotoPath: clearAvatarPhotoPath,
    );
    return _profile;
  }
}
