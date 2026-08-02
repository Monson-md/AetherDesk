/// Strings that must never be translated: log tags, fallback text used
/// before localization is initialized, and internal identifiers.
///
/// User-facing text belongs in `lib/l10n/*.arb` via [AppLocalizations],
/// never here.
abstract final class AppStrings {
  static const String appName = 'AetherDesk';
  static const String logTag = 'AetherDesk';
  static const String unknownErrorFallback = 'Unknown error';
}
