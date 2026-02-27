import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../l10n/app_localizations.dart';
import 'language_model.dart';

class L10nConfig {
  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      fontFamily: 'Poppins',
    ),
    LanguageModel(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      fontFamily: 'Poppins',
    ),
    LanguageModel(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      isRTL: true,
      fontFamily: 'Amiri',
    ),
  ];

  static List<Locale> get supportedLocales =>
      supportedLanguages.map((lang) => Locale(lang.code)).toList();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static LanguageModel getLanguageByCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => supportedLanguages.first,
    );
  }
}
