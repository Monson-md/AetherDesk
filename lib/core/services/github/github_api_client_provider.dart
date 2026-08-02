import 'package:aetherdesk/core/auth/auth_controller.dart';
import 'package:aetherdesk/core/services/github/github_api_client.dart';
import 'package:aetherdesk/core/services/github/github_auth_service.dart';
import 'package:aetherdesk/core/services/storage/secure_storage_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wires [GithubApiClient] to the app's real token storage and auth state —
/// the only file that needs to know about both `core/services/github` and
/// `core/auth`, so neither of those depends on the other directly.
final githubApiClientProvider = Provider<GithubApiClient>((ref) {
  return GithubApiClient(
    tokenProvider: () =>
        ref.read(secureStorageServiceProvider).read(githubTokenStorageKey),
    onUnauthorized: () => ref.read(authControllerProvider.notifier).logout(),
  );
});
