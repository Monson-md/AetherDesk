import 'package:aetherdesk/core/services/github/github_api_client.dart';
import 'package:aetherdesk/features/user_profile/domain/entities/user_profile.dart';
import 'package:aetherdesk/features/user_profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl(this._apiClient);

  final GithubApiClient _apiClient;

  @override
  Future<UserProfile> getCurrentUserProfile() async {
    final json = await _apiClient.getJson('/user');
    return UserProfile(
      login: json['login'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String,
      publicRepos: json['public_repos'] as int? ?? 0,
    );
  }
}
