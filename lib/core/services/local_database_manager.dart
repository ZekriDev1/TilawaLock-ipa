import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabaseManager {
  static const String settingsBoxName = 'settings';
  static const String statsBoxName = 'stats';
  static const String appsBoxName = 'locked_apps';
  static const String achievementsBoxName = 'achievements';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(statsBoxName);
    await Hive.openBox(appsBoxName);
    await Hive.openBox(achievementsBoxName);
  }

  static Box get settingsBox => Hive.box(settingsBoxName);
  static Box get statsBox => Hive.box(statsBoxName);
  static Box get appsBox => Hive.box(appsBoxName);
  static Box get achievementsBox => Hive.box(achievementsBoxName);

  // Settings
  static Future<void> saveUsageLimit(int minutes) async {
    await settingsBox.put('usage_limit', minutes);
  }

  static int getUsageLimit() {
    return settingsBox.get('usage_limit', defaultValue: 60);
  }

  static Future<void> saveLanguage(String languageCode) async {
    await settingsBox.put('language_code', languageCode);
  }

  static String? getLanguage() {
    return settingsBox.get('language_code');
  }

  // Apps
  static Future<void> setLockedApps(List<String> packageNames) async {
    await appsBox.put('list', packageNames);
  }

  static List<String> getLockedApps() {
    return List<String>.from(appsBox.get('list', defaultValue: []));
  }

  // Stats
  static Future<void> updateStreak(int days) async {
    await statsBox.put('streak', days);
  }

  static int getStreak() {
    return statsBox.get('streak', defaultValue: 0);
  }

  static Future<void> addVerses(int count) async {
    int current = statsBox.get('verses', defaultValue: 0);
    await statsBox.put('verses', current + count);
  }

  static int getVerses() {
    return statsBox.get('verses', defaultValue: 0);
  }

  static Future<void> addPoints(int points) async {
    int current = statsBox.get('points', defaultValue: 0);
    await statsBox.put('points', current + points);
  }

  static int getPoints() {
    return statsBox.get('points', defaultValue: 0);
  }

  static Future<void> addTimeSaved(int minutes) async {
    int current = statsBox.get('time_saved', defaultValue: 0);
    await statsBox.put('time_saved', current + minutes);
  }

  static int getTimeSaved() {
    return statsBox.get('time_saved', defaultValue: 0);
  }

  // Achievements
  static Future<void> unlockAchievement(String id) async {
    await achievementsBox.put(id, true);
  }

  static bool isAchievementUnlocked(String id) {
    return achievementsBox.get(id, defaultValue: false);
  }
}
