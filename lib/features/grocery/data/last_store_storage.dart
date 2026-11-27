import 'package:shared_preferences/shared_preferences.dart';

/// Remembers on this phone which store's list Mom had open last, so the app
/// opens on it next time.
class LastStoreStorage {
  new([SharedPreferencesAsync? preferences])
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _key = 'lastStoreId';

  final SharedPreferencesAsync _preferences;

  /// The id of the store last opened, or null if none was saved.
  Future<String?> read() => _preferences.getString(_key);

  /// Saves [storeId] as the store last opened.
  Future<void> write(String storeId) => _preferences.setString(_key, storeId);
}
