import 'package:aetherdesk/features/user_profile/domain/entities/country.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';
import 'package:aetherdesk/features/user_profile/domain/repositories/user_profile_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final UserProfileRepository _repository;

  UserProfile call({
    String? firstName,
    String? lastName,
    String? username,
    String? bio,
    Country? country,
    int? avatarColorValue,
    int? avatarIconIndex,
  }) {
    return _repository.updateProfile(
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
