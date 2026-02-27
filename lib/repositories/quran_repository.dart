import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../services/quran_api_service.dart';
import '../services/quran_cache_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class QuranRepository {
  final QuranApiService _apiService;
  final QuranCacheService _cacheService;

  QuranRepository(this._apiService, this._cacheService);

  Future<bool> _isOffline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.none;
  }

  Future<List<SurahModel>> getSurahList() async {
    final cached = _cacheService.getCachedSurahList();
    
    if (await _isOffline()) {
      if (cached != null) return cached;
      throw Exception('offline');
    }

    try {
      final surahs = await _apiService.getAllSurahs();
      await _cacheService.setCachedSurahList(surahs);
      return surahs;
    } catch (e) {
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<SurahModel> getSurah(int number, {String? edition}) async {
    final isOffline = await _isOffline();
    
    if (_cacheService.hasCachedSurah(number)) {
      final cached = _cacheService.getCachedSurah(number);
      if (cached != null && !isOffline) {
        // Background update if online but has cache
        _apiService.getSurah(number, edition: edition).then((updated) {
          _cacheService.setCachedSurah(updated);
        }).catchError((_) {});
        return cached;
      }
      if (cached != null) return cached;
    }

    if (isOffline) throw Exception('offline');

    final surah = await _apiService.getSurah(number, edition: edition);
    await _cacheService.setCachedSurah(surah);
    return surah;
  }

  Future<AyahModel> getAyah(int surah, int ayah, {String? edition}) async {
    if (await _isOffline()) throw Exception('offline');
    return await _apiService.getAyah(surah, ayah, edition: edition);
  }

  Future<List<AyahModel>> searchAyahs(String keyword, {String language = 'en'}) async {
    if (await _isOffline()) throw Exception('offline');
    return await _apiService.searchAyahs(keyword, language: language);
  }

  Future<void> clearCache() => _cacheService.clearCache();
}
