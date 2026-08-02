/// Contract for non-sensitive key/value persistence (preferences, cached
/// settings, UI state such as the last selected module).
///
/// No concrete implementation yet — adding one later (e.g. backed by
/// `shared_preferences`) only means implementing this interface and
/// registering it as a Riverpod provider.
abstract interface class LocalStorageService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);

  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);

  Future<void> remove(String key);
  Future<void> clear();
}
