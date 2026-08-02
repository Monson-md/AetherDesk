import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';

abstract interface class UserProfileRepository {
  Future<UserProfile> getCurrentUserProfile();
}
