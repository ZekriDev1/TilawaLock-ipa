import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah_model.dart';
import '../core/constants/storage_keys.dart';

class QuranCacheService {
  final SharedPreferences _prefs;

  QuranCacheService(this._prefs);

  static const Duration _cacheTTL = Duration(hours: 24);

  bool hasCachedSurah(int number) {
    final timestamp = _prefs.getInt(StorageKeys.surahCacheTimestamp(number));
    if (timestamp == null) return false;
    
    final lastWrite = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(lastWrite) < _cacheTTL;
  }

  SurahModel? getCachedSurah(int number) {
    final jsonString = _prefs.getString(StorageKeys.surahCache(number));
    if (jsonString == null) return null;
    return SurahModel.fromJson(json.decode(jsonString));
  }

  Future<void> setCachedSurah(SurahModel surah) async {
    await _prefs.setString(StorageKeys.surahCache(surah.number), json.encode(surah.toJson()));
    await _prefs.setInt(StorageKeys.surahCacheTimestamp(surah.number), DateTime.now().millisecondsSinceEpoch);
  }

  List<SurahModel>? getCachedSurahList() {
    final jsonString = _prefs.getString(StorageKeys.surahListCache);
    if (jsonString == null) return null;
    final List<dynamic> listData = json.decode(jsonString);
    return listData.map((s) => SurahModel.fromJson(s)).toList();
  }

  Future<void> setCachedSurahList(List<SurahModel> surahs) async {
    final jsonString = json.encode(surahs.map((s) => s.toJson()).toList());
    await _prefs.setString(StorageKeys.surahListCache, jsonString);
  }

  Future<void> clearCache() async {
    final keys = _prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('surah_cache_') || key == StorageKeys.surahListCache) {
        await _prefs.remove(key);
      }
    }
  }
}
