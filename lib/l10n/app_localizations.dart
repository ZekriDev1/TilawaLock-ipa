import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Tilawa Lock'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Recite to Unlock'**
  String get appTagline;

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen Locked'**
  String get unlockTitle;

  /// No description provided for @unlockInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please recite the ayah below to unlock'**
  String get unlockInstruction;

  /// No description provided for @unlockButton.
  ///
  /// In en, this message translates to:
  /// **'Tap to Recite'**
  String get unlockButton;

  /// No description provided for @unlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Unlock Successful'**
  String get unlockSuccess;

  /// No description provided for @unlockFail.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Recitation'**
  String get unlockFail;

  /// No description provided for @recitationTitle.
  ///
  /// In en, this message translates to:
  /// **'Recitation'**
  String get recitationTitle;

  /// No description provided for @recitationStart.
  ///
  /// In en, this message translates to:
  /// **'Start Reciting'**
  String get recitationStart;

  /// No description provided for @recitationStop.
  ///
  /// In en, this message translates to:
  /// **'Stop Reciting'**
  String get recitationStop;

  /// No description provided for @recitationListening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get recitationListening;

  /// No description provided for @recitationCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get recitationCorrect;

  /// No description provided for @recitationIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect, please try again'**
  String get recitationIncorrect;

  /// No description provided for @recitationRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get recitationRetry;

  /// No description provided for @ayatRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No ayahs remaining} =1{1 ayah remaining} other{{count} ayahs remaining}}'**
  String ayatRemaining(int count);

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStep(int current, int total);

  /// No description provided for @ramadanModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Mode'**
  String get ramadanModeTitle;

  /// No description provided for @ramadanModeActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get ramadanModeActive;

  /// No description provided for @ramadanModeInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get ramadanModeInactive;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsPermissionsSection.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get settingsPermissionsSection;

  /// No description provided for @settingsQuranSection.
  ///
  /// In en, this message translates to:
  /// **'Quran Settings'**
  String get settingsQuranSection;

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Quran Cache'**
  String get settingsClearCache;

  /// No description provided for @settingsClearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the Quran cache?'**
  String get settingsClearCacheConfirm;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @permissionMicTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone Access'**
  String get permissionMicTitle;

  /// No description provided for @permissionMicBody.
  ///
  /// In en, this message translates to:
  /// **'Tilawa Lock needs microphone access to verify your recitation.'**
  String get permissionMicBody;

  /// No description provided for @permissionMicDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get permissionMicDenied;

  /// No description provided for @permissionMicPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is permanently denied. Please enable it in settings.'**
  String get permissionMicPermanentlyDenied;

  /// No description provided for @permissionMicOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get permissionMicOpenSettings;

  /// No description provided for @permissionNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permissionNotifTitle;

  /// No description provided for @permissionNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Stay on track with daily recitation reminders.'**
  String get permissionNotifBody;

  /// No description provided for @permissionNotifDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied'**
  String get permissionNotifDenied;

  /// No description provided for @permissionOverlayTitle.
  ///
  /// In en, this message translates to:
  /// **'Draw Over Apps'**
  String get permissionOverlayTitle;

  /// No description provided for @permissionOverlayBody.
  ///
  /// In en, this message translates to:
  /// **'Required to show the lock screen over other apps.'**
  String get permissionOverlayBody;

  /// No description provided for @permissionOverlayOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Enable Overlay'**
  String get permissionOverlayOpenSettings;

  /// No description provided for @permissionOverlayNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Overlay not available on this device'**
  String get permissionOverlayNotAvailable;

  /// No description provided for @permissionStatusGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get permissionStatusGranted;

  /// No description provided for @permissionStatusDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get permissionStatusDenied;

  /// No description provided for @permissionStatusNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get permissionStatusNotAvailable;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get onboardingGrantPermission;

  /// No description provided for @onboardingOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get onboardingOpenSettings;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get onboardingDone;

  /// No description provided for @quranSurahListTitle.
  ///
  /// In en, this message translates to:
  /// **'Holy Quran'**
  String get quranSurahListTitle;

  /// No description provided for @quranSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search Surahs...'**
  String get quranSearchPlaceholder;

  /// No description provided for @quranMeccan.
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get quranMeccan;

  /// No description provided for @quranMedinan.
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get quranMedinan;

  /// No description provided for @quranAyahCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Ayahs'**
  String quranAyahCount(int count);

  /// No description provided for @quranSurahNumber.
  ///
  /// In en, this message translates to:
  /// **'Surah {number}'**
  String quranSurahNumber(int number);

  /// No description provided for @quranLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading Quran...'**
  String get quranLoading;

  /// No description provided for @quranLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load Quran data'**
  String get quranLoadError;

  /// No description provided for @quranRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get quranRetry;

  /// No description provided for @quranOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Showing cached data.'**
  String get quranOfflineBanner;

  /// No description provided for @quranOfflineError.
  ///
  /// In en, this message translates to:
  /// **'You are offline and no cached data is available.'**
  String get quranOfflineError;

  /// No description provided for @quranSurahDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Surah Detail'**
  String get quranSurahDetailTitle;

  /// No description provided for @quranAssignAyah.
  ///
  /// In en, this message translates to:
  /// **'Assign as Target'**
  String get quranAssignAyah;

  /// No description provided for @quranAyahAssigned.
  ///
  /// In en, this message translates to:
  /// **'Ayah assigned successfully!'**
  String get quranAyahAssigned;

  /// No description provided for @quranTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get quranTranslation;

  /// No description provided for @quranAyahSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Ayahs'**
  String get quranAyahSearchTitle;

  /// No description provided for @quranAyahSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter keyword...'**
  String get quranAyahSearchPlaceholder;

  /// No description provided for @quranAyahSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No ayahs found for this keyword'**
  String get quranAyahSearchNoResults;

  /// No description provided for @quranBrowseBySurah.
  ///
  /// In en, this message translates to:
  /// **'Browse by Surah'**
  String get quranBrowseBySurah;

  /// No description provided for @quranAssignmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Target Ayah'**
  String get quranAssignmentTitle;

  /// No description provided for @quranAssignmentNone.
  ///
  /// In en, this message translates to:
  /// **'No target ayah assigned'**
  String get quranAssignmentNone;

  /// No description provided for @quranAssignmentClear.
  ///
  /// In en, this message translates to:
  /// **'Clear Target'**
  String get quranAssignmentClear;

  /// No description provided for @quranAssignmentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear this assignment?'**
  String get quranAssignmentConfirm;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error, check connection'**
  String get errorNetwork;

  /// No description provided for @errorMicUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Microphone is unavailable'**
  String get errorMicUnavailable;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorOffline;

  /// No description provided for @errorApiTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get errorApiTimeout;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get errorNotFound;

  /// No description provided for @motivational1.
  ///
  /// In en, this message translates to:
  /// **'Keep going! You\'re doing great.'**
  String get motivational1;

  /// No description provided for @motivational2.
  ///
  /// In en, this message translates to:
  /// **'Every letter is a reward.'**
  String get motivational2;

  /// No description provided for @motivational3.
  ///
  /// In en, this message translates to:
  /// **'Consistency is key.'**
  String get motivational3;

  /// No description provided for @motivational4.
  ///
  /// In en, this message translates to:
  /// **'Connect with the Quran daily.'**
  String get motivational4;

  /// No description provided for @motivational5.
  ///
  /// In en, this message translates to:
  /// **'May Allah bless your efforts.'**
  String get motivational5;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @openSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get openSettingsButton;

  /// No description provided for @grantButton.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get grantButton;

  /// No description provided for @manageButton.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manageButton;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
