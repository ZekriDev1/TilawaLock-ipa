import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recitation_assignment_model.dart';
import '../repositories/quran_repository.dart';
import '../core/constants/storage_keys.dart';

enum SessionResult { none, correct, incorrect }

class RecitationProvider extends ChangeNotifier {
  final QuranRepository _repository;
  final SharedPreferences _prefs;

  RecitationAssignmentModel? _currentAssignment;
  bool _isSessionActive = false;
  SessionResult _lastSessionResult = SessionResult.none;

  RecitationProvider(this._repository, this._prefs) {
    _loadAssignment();
  }

  RecitationAssignmentModel? get currentAssignment => _currentAssignment;
  bool get hasAssignment => _currentAssignment != null;
  bool get isSessionActive => _isSessionActive;
  SessionResult get lastSessionResult => _lastSessionResult;

  void _loadAssignment() {
    final surahNum = _prefs.getInt(StorageKeys.assignedSurahNumber);
    if (surahNum != null) {
      _currentAssignment = RecitationAssignmentModel(
        surahNumber: surahNum,
        surahName: _prefs.getString('assigned_surah_name') ?? '',
        ayahNumber: _prefs.getInt(StorageKeys.assignedAyahNumber) ?? 1,
        arabicText: _prefs.getString(StorageKeys.assignedAyahArabic) ?? '',
        translationText: _prefs.getString(StorageKeys.assignedAyahTranslation) ?? '',
        audioUrl: _prefs.getString(StorageKeys.assignedAyahAudioUrl),
        assignedAt: DateTime.now(), // Placeholder or load from storage
      );
    }
    notifyListeners();
  }

  Future<void> assignAyah(int surahNumber, String surahName, int ayahNumber, String languageCode) async {
    try {
      // Fetch fresh data for both Arabic and translation
      final arabicAyah = await _repository.getAyah(surahNumber, ayahNumber, edition: 'quran-uthmani');
      
      String transEdition = 'en.sahih';
      if (languageCode == 'fr') transEdition = 'fr.hamidullah';
      if (languageCode == 'ar') transEdition = 'quran-uthmani'; // Same if Arabic

      final transAyah = await _repository.getAyah(surahNumber, ayahNumber, edition: transEdition);

      _currentAssignment = RecitationAssignmentModel(
        surahNumber: surahNumber,
        surahName: surahName,
        ayahNumber: ayahNumber,
        arabicText: arabicAyah.text,
        translationText: transAyah.text,
        audioUrl: arabicAyah.audioUrl,
        assignedAt: DateTime.now(),
      );

      // Persist
      await _prefs.setInt(StorageKeys.assignedSurahNumber, surahNumber);
      await _prefs.setString('assigned_surah_name', surahName);
      await _prefs.setInt(StorageKeys.assignedAyahNumber, ayahNumber);
      await _prefs.setString(StorageKeys.assignedAyahArabic, arabicAyah.text);
      await _prefs.setString(StorageKeys.assignedAyahTranslation, transAyah.text);
      if (arabicAyah.audioUrl != null) {
        await _prefs.setString(StorageKeys.assignedAyahAudioUrl, arabicAyah.audioUrl!);
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearAssignment() async {
    _currentAssignment = null;
    await _prefs.remove(StorageKeys.assignedSurahNumber);
    await _prefs.remove('assigned_surah_name');
    await _prefs.remove(StorageKeys.assignedAyahNumber);
    await _prefs.remove(StorageKeys.assignedAyahArabic);
    await _prefs.remove(StorageKeys.assignedAyahTranslation);
    await _prefs.remove(StorageKeys.assignedAyahAudioUrl);
    notifyListeners();
  }

  void startSession() {
    _isSessionActive = true;
    _lastSessionResult = SessionResult.none;
    notifyListeners();
  }

  void stopSession(SessionResult result) {
    _isSessionActive = false;
    _lastSessionResult = result;
    notifyListeners();
  }
}
