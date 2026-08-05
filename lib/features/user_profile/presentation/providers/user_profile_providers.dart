import 'package:aetherdesk/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:aetherdesk/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:aetherdesk/features/user_profile/domain/usecases/get_profile_usecase.dart';
import 'package:aetherdesk/features/user_profile/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl();
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.watch(userProfileRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(userProfileRepositoryProvider));
});
