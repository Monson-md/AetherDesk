import 'package:aetherdesk/core/services/github/github_auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single place to swap [GithubAuthService] for a different
/// implementation (e.g. a fake one in tests).
final githubAuthServiceProvider = Provider<GithubAuthService>(
  (ref) => GithubAuthServiceImpl(),
);
