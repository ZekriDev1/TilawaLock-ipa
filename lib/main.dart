import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/services/local_database_manager.dart';
import 'core/services/usage_tracking_service.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/lock_overlay_screen.dart';

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LockOverlayScreen(),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Local Database (Hive)
  await LocalDatabaseManager.init();

  // Start background monitoring for locked apps
  UsageTrackingService().startMonitoring();
  
  runApp(
    const ProviderScope(
      child: TilawaLockApp(),
    ),
  );
}

class TilawaLockApp extends ConsumerWidget {
  const TilawaLockApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Tilawa Lock',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashScreen(),
    );
  }
}
