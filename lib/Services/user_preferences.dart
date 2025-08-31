import 'package:hive/hive.dart';

class UserPreferences {
  static final _box = Hive.box('userData');

  // Save settings
  static Future<void> saveSettings({
    required String nickname,
    required String botTone,
    required String theme,
    required bool notificationsEnabled,
  }) async {
    await _box.put('nickname', nickname);
    await _box.put('botTone', botTone);
    await _box.put('theme', theme);
    await _box.put('notifications', notificationsEnabled);
  }

  // Getters
  static String get nickname => _box.get('nickname', defaultValue: 'Guest');
  static String get botTone => _box.get('botTone', defaultValue: 'Playful');
  static String get theme => _box.get('theme', defaultValue: 'Light');
  static bool get notifications =>
      _box.get('notifications', defaultValue: true);
}
