import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';
import 'package:aetherdesk/features/user_profile/domain/repositories/user_profile_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final UserProfileRepository _repository;

  UserProfile call() {
    return _repository.getProfile();
  }
}
