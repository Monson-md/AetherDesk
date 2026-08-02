import 'package:aetherdesk/core/services/github/github_api_client_provider.dart';
import 'package:aetherdesk/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:aetherdesk/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:aetherdesk/features/user_profile/domain/usecases/get_current_user_profile_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl(ref.watch(githubApiClientProvider));
});

final getCurrentUserProfileUseCaseProvider =
    Provider<GetCurrentUserProfileUseCase>((ref) {
      return GetCurrentUserProfileUseCase(
        ref.watch(userProfileRepositoryProvider),
      );
    });
