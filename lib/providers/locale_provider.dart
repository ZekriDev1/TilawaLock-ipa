import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../core/localization/l10n_config.dart';
import '../core/localization/language_model.dart';

class LocaleProvider extends ChangeNotifier {
  final LanguageService _languageService;
  late Locale _locale;

  LocaleProvider(this._languageService) {
    final code = _languageService.getSavedLanguageCode();
    _locale = Locale(code);
  }

  Locale get locale => _locale;
  
  LanguageModel get currentLanguage => L10nConfig.getLanguageByCode(_locale.languageCode);

  Future<void> setLocale(String code) async {
    if (_locale.languageCode == code) return;
    
    _locale = Locale(code);
    await _languageService.setLanguageCode(code);
    notifyListeners();
  }
}
