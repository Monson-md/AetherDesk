import 'package:aetherdesk/features/user_profile/domain/entities/country.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';

/// Module-level contract for the single local [UserProfile].
///
/// The current implementation (`UserProfileRepositoryImpl`) keeps state in
/// memory for the session. This interface is the swap point: a future
/// `FirestoreUserProfileRepository` could read/write through the already
/// contracted `core/services/firebase/firestore/FirestoreRepository`
/// instead, and nothing in `domain/usecases` or `presentation/` would need
/// to change — only the Riverpod provider wiring in
/// `user_profile_providers.dart`.
abstract interface class UserProfileRepository {
  UserProfile getProfile();

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
  });
}
