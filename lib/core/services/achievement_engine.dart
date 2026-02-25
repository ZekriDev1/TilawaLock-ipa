import 'local_database_manager.dart';

class AchievementEngine {
  static const String KEY_FIRST_VERSE = 'first_verse';
  static const String KEY_THREE_DAY_STREAK = 'three_day_streak';
  static const String KEY_NIGHT_OWL = 'night_owl';
  static const String KEY_KHATIM = 'khatim';

  static Future<void> checkAchievements() async {
    int streak = LocalDatabaseManager.getStreak();
    int verses = LocalDatabaseManager.getVerses();
    
    // First Verse
    if (verses >= 1) {
      await _unlock(KEY_FIRST_VERSE);
    }
    
    // 3 Day Streak
    if (streak >= 3) {
      await _unlock(KEY_THREE_DAY_STREAK);
    }

    // Custom logic for other achievements can be added here
    // based on real tracked actions.
  }

  static Future<void> _unlock(String id) async {
    if (!LocalDatabaseManager.isAchievementUnlocked(id)) {
      await LocalDatabaseManager.unlockAchievement(id);
    }
  }

  static Future<void> addPoints(int points) async {
    await LocalDatabaseManager.addPoints(points);
    await checkAchievements();
  }

  static Future<void> onVerseRecited() async {
    await LocalDatabaseManager.addVerses(1);
    await checkAchievements();
  }
}
