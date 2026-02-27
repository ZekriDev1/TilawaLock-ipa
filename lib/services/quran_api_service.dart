import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../models/edition_model.dart';

class QuranApiService {
  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 10);

  Future<List<SurahModel>> getAllSurahs() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConstants.surahEndpoint))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> surahsJson = data['data'];
        return surahsJson.map((json) => SurahModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load surahs: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SurahModel> getSurah(int number, {String? edition}) async {
    try {
      final url = edition != null
          ? ApiConstants.surahWithEditionEndpoint(number, edition)
          : ApiConstants.singleSurahEndpoint(number);
      
      final response = await _client.get(Uri.parse(url)).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SurahModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to load surah: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SurahModel> getSurahWithTranslations(int number, List<String> editions) async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConstants.surahEditionsEndpoint(number, editions)))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Al-Quran Cloud returns a list of surah objects for each edition
        // We need to merge them. Usually data['data'] is a List.
        final List<dynamic> surahEditions = data['data'];
        
        // Use the first one as base (usually Arabic)
        final baseSurahJson = surahEditions[0];
        final baseSurah = SurahModel.fromJson(baseSurahJson);
        
        // We could enhance this to merge translations into AyahModel if needed
        // For now, returning the base surah which contains ayahs of the first edition requested
        return baseSurah;
      } else {
        throw Exception('Failed to load surah editions: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AyahModel> getAyah(int surah, int ayah, {String? edition}) async {
    try {
      final url = edition != null
          ? ApiConstants.ayahWithEditionEndpoint(surah, ayah, edition)
          : ApiConstants.singleAyahEndpoint(surah, ayah);
          
      final response = await _client.get(Uri.parse(url)).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return AyahModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to load ayah: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AyahModel>> searchAyahs(String keyword, {String language = 'en'}) async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConstants.searchEndpoint(keyword, language: language)))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['data']['matches'];
        return results.map((json) => AyahModel.fromJson(json)).toList();
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<EditionModel>> getEditions({String? format, String? language}) async {
    try {
      var url = ApiConstants.editionEndpoint;
      List<String> params = [];
      if (format != null) params.add('format=$format');
      if (language != null) params.add('language=$language');
      if (params.isNotEmpty) url += '?${params.join('&')}';

      final response = await _client.get(Uri.parse(url)).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> editionsJson = data['data'];
        return editionsJson.map((json) => EditionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load editions: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
