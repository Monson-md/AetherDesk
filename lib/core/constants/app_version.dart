/// Kept in sync by hand with `pubspec.yaml`'s `version:` line — this app
/// has no `package_info_plus` dependency to read it at runtime, and adding
/// one just for this static display isn't worth it. Shared between the
/// settings "App info" display and `GithubAppUpdateService` (which compares
/// [appVersion] against the latest GitHub release tag).
const String appVersion = '1.0.0';
const String appBuildNumber = '1';
