import 'package:flutter/material.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../repositories/quran_repository.dart';

class QuranProvider extends ChangeNotifier {
  final QuranRepository _repository;

  List<SurahModel> _surahList = [];
  List<AyahModel> _searchResults = [];
  SurahModel? _currentSurah;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOffline = false;

  QuranProvider(this._repository);

  List<SurahModel> get surahList => _surahList;
  List<AyahModel> get searchResults => _searchResults;
  SurahModel? get currentSurah => _currentSurah;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;
  QuranRepository get repository => _repository;

  Future<void> fetchSurahList() async {
    _isLoading = true;
    _errorMessage = null;
    _isOffline = false;
    notifyListeners();

    try {
      _surahList = await _repository.getSurahList();
    } catch (e) {
      if (e.toString().contains('offline')) {
        _isOffline = true;
      } else {
        _errorMessage = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSurahDetail(int number, String languageCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Automatic edition selection based on locale
      String edition = 'quran-uthmani';
      if (languageCode == 'en') edition = 'en.sahih';
      if (languageCode == 'fr') edition = 'fr.hamidullah';

      _currentSurah = await _repository.getSurah(number, edition: edition);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> searchAyahs(String keyword, String languageCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _repository.searchAyahs(keyword, language: languageCode);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCache() => _repository.clearCache();
}
