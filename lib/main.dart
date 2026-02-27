import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'core/localization/l10n_config.dart';
import 'services/language_service.dart';
import 'services/permission_service.dart';
import 'services/quran_api_service.dart';
import 'services/quran_cache_service.dart';
import 'repositories/quran_repository.dart';
import 'providers/locale_provider.dart';
import 'providers/permission_provider.dart';
import 'providers/quran_provider.dart';
import 'providers/recitation_provider.dart';
import 'screens/onboarding/permission_request_screen.dart';
import 'screens/quran/surah_list_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize Services
  final languageService = LanguageService(prefs);
  final permissionService = PermissionService();
  final quranApiService = QuranApiService();
  final quranCacheService = QuranCacheService(prefs);
  
  // Initialize Repositories
  final quranRepository = QuranRepository(quranApiService, quranCacheService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider(languageService)),
        ChangeNotifierProvider(create: (_) => PermissionProvider(permissionService)),
        ChangeNotifierProvider(create: (_) => QuranProvider(quranRepository)),
        ChangeNotifierProvider(create: (_) => RecitationProvider(quranRepository, prefs)),
      ],
      child: const TilawaLockApp(),
    ),
  );
}

class TilawaLockApp extends StatelessWidget {
  const TilawaLockApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final language = localeProvider.currentLanguage;

    return MaterialApp(
      title: 'Tilawa Lock',
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      supportedLocales: L10nConfig.supportedLocales,
      localizationsDelegates: L10nConfig.localizationsDelegates,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: language.fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20), // Quranic Green
          brightness: Brightness.light,
        ),
      ),
      home: const OnboardingGuard(),
    );
  }
}

class OnboardingGuard extends StatelessWidget {
  const OnboardingGuard({super.key});

  @override
  Widget build(BuildContext context) {
    // Check onboarding status from SharedPreferences (indirectly or via service)
    // For now, let's assume we logic it here
    return const PermissionRequestScreen(); 
  }
}
