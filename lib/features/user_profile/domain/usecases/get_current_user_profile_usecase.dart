import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';
import 'package:aetherdesk/features/user_profile/domain/repositories/user_profile_repository.dart';

class GetCurrentUserProfileUseCase {
  const GetCurrentUserProfileUseCase(this._repository);

  final UserProfileRepository _repository;

  Future<UserProfile> call() => _repository.getCurrentUserProfile();
}
