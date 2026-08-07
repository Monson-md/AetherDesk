import 'package:aetherdesk/core/services/firebase/auth/firebase_auth_providers.dart';
import 'package:aetherdesk/core/services/firebase/firestore/firestore_providers.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';
import 'package:aetherdesk/features/user_profile/presentation/providers/user_profile_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _profilesCollection = 'profiles';

enum CloudBackupResult { success, notSignedIn, notFound, failure }

/// Backs up/restores the local [UserProfile] to/from Firestore under
/// `profiles/{uid}` — requires the optional Firebase account from
/// `CloudAccountSection`; local-only usage of the app is unaffected if the
/// user never signs in.
class CloudBackupController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<CloudBackupResult> backupNow() async {
    final uid = ref.read(firebaseAuthRepositoryProvider).currentUser?.uid;
    if (uid == null) return CloudBackupResult.notSignedIn;
    state = const AsyncLoading();
    try {
      final profile = ref.read(userProfileControllerProvider);
      await ref
          .read(firestoreRepositoryProvider)
          .save(_profilesCollection, uid, profile.toJson(), merge: true);
      state = const AsyncData(null);
      return CloudBackupResult.success;
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return CloudBackupResult.failure;
    }
  }

  Future<CloudBackupResult> restoreNow() async {
    final uid = ref.read(firebaseAuthRepositoryProvider).currentUser?.uid;
    if (uid == null) return CloudBackupResult.notSignedIn;
    state = const AsyncLoading();
    try {
      final document = await ref
          .read(firestoreRepositoryProvider)
          .fetchDocument(_profilesCollection, uid);
      if (document == null) {
        state = const AsyncData(null);
        return CloudBackupResult.notFound;
      }
      final restored = UserProfile.fromJson(document.data);
      ref
          .read(userProfileControllerProvider.notifier)
          .updateProfile(
            firstName: restored.firstName,
            lastName: restored.lastName,
            username: restored.username,
            bio: restored.bio,
            country: restored.country,
            avatarColorValue: restored.avatarColorValue,
            avatarIconIndex: restored.avatarIconIndex,
          );
      state = const AsyncData(null);
      return CloudBackupResult.success;
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return CloudBackupResult.failure;
    }
  }
}

final cloudBackupControllerProvider =
    NotifierProvider<CloudBackupController, AsyncValue<void>>(
      CloudBackupController.new,
    );
