import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/storage_keys.dart';
import '../core/localization/l10n_config.dart';

class LanguageService {
  final SharedPreferences _prefs;

  LanguageService(this._prefs);

  String getSavedLanguageCode() {
    return _prefs.getString(StorageKeys.languageCode) ?? _detectDeviceLanguage();
  }

  Future<void> setLanguageCode(String code) async {
    await _prefs.setString(StorageKeys.languageCode, code);
  }

  String _detectDeviceLanguage() {
    final deviceLocale = Platform.localeName.split('_')[0];
    final isSupported = L10nConfig.supportedLanguages.any((lang) => lang.code == deviceLocale);
    
    final resolvedCode = isSupported ? deviceLocale : 'en';
    // Save it for future launches
    _prefs.setString(StorageKeys.languageCode, resolvedCode);
    return resolvedCode;
  }
}
