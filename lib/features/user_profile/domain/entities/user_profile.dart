/// The signed-in GitHub user, as shown on the profile screen. Decoupled
/// from the raw `GET /user` JSON shape on purpose — `data/` owns that
/// mapping so a future richer profile source doesn't ripple into
/// `presentation/`.
class UserProfile {
  const UserProfile({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.publicRepos,
  });

  final String login;
  final String? name;
  final String avatarUrl;
  final int publicRepos;
}
