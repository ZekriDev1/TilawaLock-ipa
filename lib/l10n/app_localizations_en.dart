// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tilawa Lock';

  @override
  String get appTagline => 'Recite to Unlock';

  @override
  String get unlockTitle => 'Screen Locked';

  @override
  String get unlockInstruction => 'Please recite the ayah below to unlock';

  @override
  String get unlockButton => 'Tap to Recite';

  @override
  String get unlockSuccess => 'Unlock Successful';

  @override
  String get unlockFail => 'Incorrect Recitation';

  @override
  String get recitationTitle => 'Recitation';

  @override
  String get recitationStart => 'Start Reciting';

  @override
  String get recitationStop => 'Stop Reciting';

  @override
  String get recitationListening => 'Listening...';

  @override
  String get recitationCorrect => 'Correct!';

  @override
  String get recitationIncorrect => 'Incorrect, please try again';

  @override
  String get recitationRetry => 'Retry';

  @override
  String ayatRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ayahs remaining',
      one: '1 ayah remaining',
      zero: 'No ayahs remaining',
    );
    return '$_temp0';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get ramadanModeTitle => 'Ramadan Mode';

  @override
  String get ramadanModeActive => 'Active';

  @override
  String get ramadanModeInactive => 'Inactive';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageTitle => 'App Language';

  @override
  String get settingsPermissionsSection => 'Permissions';

  @override
  String get settingsQuranSection => 'Quran Settings';

  @override
  String get settingsClearCache => 'Clear Quran Cache';

  @override
  String get settingsClearCacheConfirm =>
      'Are you sure you want to clear the Quran cache?';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'French';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get permissionMicTitle => 'Microphone Access';

  @override
  String get permissionMicBody =>
      'Tilawa Lock needs microphone access to verify your recitation.';

  @override
  String get permissionMicDenied => 'Microphone permission denied';

  @override
  String get permissionMicPermanentlyDenied =>
      'Microphone permission is permanently denied. Please enable it in settings.';

  @override
  String get permissionMicOpenSettings => 'Open Settings';

  @override
  String get permissionNotifTitle => 'Notifications';

  @override
  String get permissionNotifBody =>
      'Stay on track with daily recitation reminders.';

  @override
  String get permissionNotifDenied => 'Notification permission denied';

  @override
  String get permissionOverlayTitle => 'Draw Over Apps';

  @override
  String get permissionOverlayBody =>
      'Required to show the lock screen over other apps.';

  @override
  String get permissionOverlayOpenSettings => 'Enable Overlay';

  @override
  String get permissionOverlayNotAvailable =>
      'Overlay not available on this device';

  @override
  String get permissionStatusGranted => 'Granted';

  @override
  String get permissionStatusDenied => 'Denied';

  @override
  String get permissionStatusNotAvailable => 'N/A';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingGrantPermission => 'Grant Permission';

  @override
  String get onboardingOpenSettings => 'Open Settings';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingDone => 'Done';

  @override
  String get quranSurahListTitle => 'Holy Quran';

  @override
  String get quranSearchPlaceholder => 'Search Surahs...';

  @override
  String get quranMeccan => 'Meccan';

  @override
  String get quranMedinan => 'Medinan';

  @override
  String quranAyahCount(int count) {
    return '$count Ayahs';
  }

  @override
  String quranSurahNumber(int number) {
    return 'Surah $number';
  }

  @override
  String get quranLoading => 'Loading Quran...';

  @override
  String get quranLoadError => 'Failed to load Quran data';

  @override
  String get quranRetry => 'Retry';

  @override
  String get quranOfflineBanner => 'You are offline. Showing cached data.';

  @override
  String get quranOfflineError =>
      'You are offline and no cached data is available.';

  @override
  String get quranSurahDetailTitle => 'Surah Detail';

  @override
  String get quranAssignAyah => 'Assign as Target';

  @override
  String get quranAyahAssigned => 'Ayah assigned successfully!';

  @override
  String get quranTranslation => 'Translation';

  @override
  String get quranAyahSearchTitle => 'Search Ayahs';

  @override
  String get quranAyahSearchPlaceholder => 'Enter keyword...';

  @override
  String get quranAyahSearchNoResults => 'No ayahs found for this keyword';

  @override
  String get quranBrowseBySurah => 'Browse by Surah';

  @override
  String get quranAssignmentTitle => 'Target Ayah';

  @override
  String get quranAssignmentNone => 'No target ayah assigned';

  @override
  String get quranAssignmentClear => 'Clear Target';

  @override
  String get quranAssignmentConfirm => 'Clear this assignment?';

  @override
  String get errorGeneric => 'An error occurred';

  @override
  String get errorNetwork => 'Network error, check connection';

  @override
  String get errorMicUnavailable => 'Microphone is unavailable';

  @override
  String get errorOffline => 'No internet connection';

  @override
  String get errorApiTimeout => 'Request timed out';

  @override
  String get errorNotFound => 'Resource not found';

  @override
  String get motivational1 => 'Keep going! You\'re doing great.';

  @override
  String get motivational2 => 'Every letter is a reward.';

  @override
  String get motivational3 => 'Consistency is key.';

  @override
  String get motivational4 => 'Connect with the Quran daily.';

  @override
  String get motivational5 => 'May Allah bless your efforts.';

  @override
  String get saveButton => 'Save';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get backButton => 'Back';

  @override
  String get openSettingsButton => 'Settings';

  @override
  String get grantButton => 'Grant';

  @override
  String get manageButton => 'Manage';

  @override
  String get retryButton => 'Retry';

  @override
  String get searchButton => 'Search';
}
