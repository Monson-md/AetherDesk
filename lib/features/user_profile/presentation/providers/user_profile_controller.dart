import 'package:aetherdesk/core/error/error_handler.dart';
import 'package:aetherdesk/core/error/failure.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';
import 'package:aetherdesk/features/user_profile/presentation/providers/user_profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileState {
  const UserProfileState({this.isLoading = true, this.profile, this.failure});

  final bool isLoading;
  final UserProfile? profile;
  final Failure? failure;
}

class UserProfileController extends Notifier<UserProfileState> {
  @override
  UserProfileState build() {
    Future.microtask(loadProfile);
    return const UserProfileState();
  }

  Future<void> loadProfile() async {
    state = const UserProfileState();
    try {
      final profile = await ref
          .read(getCurrentUserProfileUseCaseProvider)
          .call();
      state = UserProfileState(isLoading: false, profile: profile);
    } catch (e) {
      state = UserProfileState(
        isLoading: false,
        failure: mapExceptionToFailure(e),
      );
    }
  }
}

final userProfileControllerProvider =
    NotifierProvider<UserProfileController, UserProfileState>(
      UserProfileController.new,
    );
