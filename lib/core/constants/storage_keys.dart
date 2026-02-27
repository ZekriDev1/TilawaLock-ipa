class StorageKeys {
  static const String languageCode = 'language_code';
  static const String onboardingComplete = 'onboarding_complete';
  
  // Recitation Assignment
  static const String assignedSurahNumber = 'assigned_surah_number';
  static const String assignedAyahNumber = 'assigned_ayah_number';
  static const String assignedAyahArabic = 'assigned_ayah_arabic';
  static const String assignedAyahTranslation = 'assigned_ayah_translation';
  static const String assignedAyahAudioUrl = 'assigned_ayah_audio_url';
  
  // Quran Cache
  static const String surahListCache = 'surah_list_cache';
  static String surahCache(int number) => 'surah_cache_$number';
  static String surahCacheTimestamp(int number) => 'surah_cache_${number}_timestamp';
}
