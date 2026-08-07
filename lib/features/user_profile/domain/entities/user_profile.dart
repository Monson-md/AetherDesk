import 'package:aetherdesk/features/user_profile/domain/entities/country.dart';

/// The local, single-user profile: identity fields plus a locally
/// customizable avatar (color + icon, not a real uploaded picture). Stored
/// locally by default; `CloudAccountSection`/`BackupSection` can optionally
/// back this up to Firestore once the user signs in, but no account is
/// required to use the app.
///
/// Language and theme are deliberately **not** here, for the same reason
/// `AppSettings` (in `features/settings`) excludes them: they're
/// cross-cutting concerns already exposed by `core/localization/` and
/// `core/theme/`, which this module's presentation layer reads/writes
/// directly instead of duplicating through this entity.
class UserProfile {
  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.bio,
    required this.country,
    required this.avatarColorValue,
    required this.avatarIconIndex,
    required this.memberSince,
  });

  factory UserProfile.initial() => UserProfile(
    firstName: '',
    lastName: '',
    username: '',
    bio: '',
    country: Country.none,
    avatarColorValue: 0xFF7C6FF0,
    avatarIconIndex: 0,
    memberSince: DateTime.now(),
  );

  final String firstName;
  final String lastName;
  final String username;
  final String bio;
  final Country country;

  /// ARGB color value (`Color.toARGB32()`), kept as an int so this entity
  /// has no Flutter import.
  final int avatarColorValue;

  /// Index into the curated icon list defined in
  /// `presentation/widgets/profile_avatar.dart`, kept as an int for the same
  /// reason as [avatarColorValue].
  final int avatarIconIndex;
  final DateTime memberSince;

  String get fullName =>
      [firstName, lastName].where((part) => part.trim().isNotEmpty).join(' ');

  /// Plain-map form used by `BackupSection`/`CloudAccountSection` to
  /// save/restore this profile through `FirestoreRepository`, which only
  /// knows `Map<String, dynamic>` documents.
  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'username': username,
    'bio': bio,
    'country': country.name,
    'avatarColorValue': avatarColorValue,
    'avatarIconIndex': avatarIconIndex,
    'memberSince': memberSince.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '',
    username: json['username'] as String? ?? '',
    bio: json['bio'] as String? ?? '',
    country: Country.values.firstWhere(
      (value) => value.name == json['country'],
      orElse: () => Country.none,
    ),
    avatarColorValue: json['avatarColorValue'] as int? ?? 0xFF7C6FF0,
    avatarIconIndex: json['avatarIconIndex'] as int? ?? 0,
    memberSince:
        DateTime.tryParse(json['memberSince'] as String? ?? '') ??
        DateTime.now(),
  );

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? bio,
    Country? country,
    int? avatarColorValue,
    int? avatarIconIndex,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      country: country ?? this.country,
      avatarColorValue: avatarColorValue ?? this.avatarColorValue,
      avatarIconIndex: avatarIconIndex ?? this.avatarIconIndex,
      memberSince: memberSince,
    );
  }
}
