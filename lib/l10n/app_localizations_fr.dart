// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Tilawa Lock';

  @override
  String get appTagline => 'Réciter pour Déverrouiller';

  @override
  String get unlockTitle => 'Écran Verrouillé';

  @override
  String get unlockInstruction =>
      'Veuillez réciter l\'ayah ci-dessous pour déverrouiller';

  @override
  String get unlockButton => 'Appuyer pour Réciter';

  @override
  String get unlockSuccess => 'Déverrouillage Réussi';

  @override
  String get unlockFail => 'Récitation Incorrecte';

  @override
  String get recitationTitle => 'Récitation';

  @override
  String get recitationStart => 'Commencer la Récitation';

  @override
  String get recitationStop => 'Arrêter la Récitation';

  @override
  String get recitationListening => 'Écoute...';

  @override
  String get recitationCorrect => 'Correct !';

  @override
  String get recitationIncorrect => 'Incorrect, veuillez réessayer';

  @override
  String get recitationRetry => 'Réessayer';

  @override
  String ayatRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ayahs restants',
      one: '1 ayah restant',
      zero: 'Aucun ayah restant',
    );
    return '$_temp0';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get ramadanModeTitle => 'Mode Ramadan';

  @override
  String get ramadanModeActive => 'Actif';

  @override
  String get ramadanModeInactive => 'Inactif';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguageSection => 'Langue';

  @override
  String get settingsLanguageTitle => 'Langue de l\'Application';

  @override
  String get settingsPermissionsSection => 'Autorisations';

  @override
  String get settingsQuranSection => 'Paramètres du Coran';

  @override
  String get settingsClearCache => 'Vider le cache du Coran';

  @override
  String get settingsClearCacheConfirm =>
      'Êtes-vous sûr de vouloir vider le cache du Coran ?';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'Arabe';

  @override
  String get permissionMicTitle => 'Accès au Microphone';

  @override
  String get permissionMicBody =>
      'Tilawa Lock a besoin de l\'accès au microphone pour vérifier votre récitation.';

  @override
  String get permissionMicDenied => 'Autorisation du microphone refusée';

  @override
  String get permissionMicPermanentlyDenied =>
      'L\'autorisation du microphone est définitivement refusée. Veuillez l\'activer dans les paramètres.';

  @override
  String get permissionMicOpenSettings => 'Ouvrir les Paramètres';

  @override
  String get permissionNotifTitle => 'Notifications';

  @override
  String get permissionNotifBody =>
      'Restez sur la bonne voie avec des rappels de récitation quotidiens.';

  @override
  String get permissionNotifDenied => 'Autorisation de notification refusée';

  @override
  String get permissionOverlayTitle => 'Affichage par-dessus';

  @override
  String get permissionOverlayBody =>
      'Requis pour afficher l\'écran de verrouillage sur d\'autres applications.';

  @override
  String get permissionOverlayOpenSettings => 'Activer l\'Affichage';

  @override
  String get permissionOverlayNotAvailable =>
      'Affichage par-dessus non disponible sur cet appareil';

  @override
  String get permissionStatusGranted => 'Accordé';

  @override
  String get permissionStatusDenied => 'Refusé';

  @override
  String get permissionStatusNotAvailable => 'N/A';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingGrantPermission => 'Accorder l\'Autorisation';

  @override
  String get onboardingOpenSettings => 'Ouvrir les Paramètres';

  @override
  String get onboardingContinue => 'Continuer';

  @override
  String get onboardingDone => 'Terminé';

  @override
  String get quranSurahListTitle => 'Saint Coran';

  @override
  String get quranSearchPlaceholder => 'Chercher des sourates...';

  @override
  String get quranMeccan => 'Meccoise';

  @override
  String get quranMedinan => 'Médinoise';

  @override
  String quranAyahCount(int count) {
    return '$count Ayahs';
  }

  @override
  String quranSurahNumber(int number) {
    return 'Sourate $number';
  }

  @override
  String get quranLoading => 'Chargement du Coran...';

  @override
  String get quranLoadError => 'Échec du chargement des données du Coran';

  @override
  String get quranRetry => 'Réessayer';

  @override
  String get quranOfflineBanner =>
      'Vous êtes hors ligne. Affichage des données en cache.';

  @override
  String get quranOfflineError =>
      'Vous êtes hors ligne et aucune donnée en cache n\'est disponible.';

  @override
  String get quranSurahDetailTitle => 'Détail de la Sourate';

  @override
  String get quranAssignAyah => 'Définir comme Cible';

  @override
  String get quranAyahAssigned => 'Ayah assigné avec succès !';

  @override
  String get quranTranslation => 'Traduction';

  @override
  String get quranAyahSearchTitle => 'Chercher des Ayahs';

  @override
  String get quranAyahSearchPlaceholder => 'Entrez un mot-clé...';

  @override
  String get quranAyahSearchNoResults => 'Aucun ayah trouvé pour ce mot-clé';

  @override
  String get quranBrowseBySurah => 'Parcourir par Sourate';

  @override
  String get quranAssignmentTitle => 'Ayah Cible';

  @override
  String get quranAssignmentNone => 'Aucun ayah cible assigné';

  @override
  String get quranAssignmentClear => 'Effacer la Cible';

  @override
  String get quranAssignmentConfirm => 'Effacer cette affectation ?';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get errorNetwork => 'Erreur réseau, vérifiez votre connexion';

  @override
  String get errorMicUnavailable => 'Microphone indisponible';

  @override
  String get errorOffline => 'Pas de connexion internet';

  @override
  String get errorApiTimeout => 'La demande a expiré';

  @override
  String get errorNotFound => 'Ressource non trouvée';

  @override
  String get motivational1 => 'Continuez ! Vous vous débrouillez bien.';

  @override
  String get motivational2 => 'Chaque lettre est une récompense.';

  @override
  String get motivational3 => 'La persévérance est la clé.';

  @override
  String get motivational4 => 'Connectez-vous au Coran quotidiennement.';

  @override
  String get motivational5 => 'Qu\'Allah bénisse vos efforts.';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get confirmButton => 'Confirmer';

  @override
  String get backButton => 'Retour';

  @override
  String get openSettingsButton => 'Paramètres';

  @override
  String get grantButton => 'Accorder';

  @override
  String get manageButton => 'Gérer';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get searchButton => 'Chercher';
}
