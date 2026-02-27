// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'تلاوة لوك';

  @override
  String get appTagline => 'رتل لتفتح';

  @override
  String get unlockTitle => 'الشاشة مقفلة';

  @override
  String get unlockInstruction => 'يرجى تلاوة الآية أدناه لفتح القفل';

  @override
  String get unlockButton => 'اضغط للتلاوة';

  @override
  String get unlockSuccess => 'تم فتح القفل بنجاح';

  @override
  String get unlockFail => 'تلاوة غير صحيحة';

  @override
  String get recitationTitle => 'التلاوة';

  @override
  String get recitationStart => 'ابدأ التلاوة';

  @override
  String get recitationStop => 'إيقاف التلاوة';

  @override
  String get recitationListening => 'جاري الاستماع...';

  @override
  String get recitationCorrect => 'صحيح!';

  @override
  String get recitationIncorrect => 'غير صحيح، يرجى المحاولة مرة أخرى';

  @override
  String get recitationRetry => 'إعادة المحاولة';

  @override
  String ayatRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آية متبقية',
      many: '$count آية متبقية',
      few: '$count آيات متبقية',
      two: 'آيتان متبقيتان',
      one: 'آية واحدة متبقية',
      zero: 'لا توجد آيات متبقية',
    );
    return '$_temp0';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get ramadanModeTitle => 'وضع رمضان';

  @override
  String get ramadanModeActive => 'نشط';

  @override
  String get ramadanModeInactive => 'غير نشط';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguageSection => 'اللغة';

  @override
  String get settingsLanguageTitle => 'لغة التطبيق';

  @override
  String get settingsPermissionsSection => 'الأذونات';

  @override
  String get settingsQuranSection => 'إعدادات القرآن';

  @override
  String get settingsClearCache => 'مسح ذاكرة التخزين المؤقت للقرآن';

  @override
  String get settingsClearCacheConfirm =>
      'هل أنت متأكد من رغبتك في مسح ذاكرة التخزين المؤقت للقرآن؟';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageFrench => 'الفرنسية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get permissionMicTitle => 'الوصول إلى الميكروفون';

  @override
  String get permissionMicBody =>
      'يحتاج تلاوة لوك إلى الوصول إلى الميكروفون للتحقق من تلاوتك.';

  @override
  String get permissionMicDenied => 'تم رفض إذن الميكروفون';

  @override
  String get permissionMicPermanentlyDenied =>
      'تم رفض إذن الميكروفون بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get permissionMicOpenSettings => 'فتح الإعدادات';

  @override
  String get permissionNotifTitle => 'الإشعارات';

  @override
  String get permissionNotifBody =>
      'ابق على المسار الصحيح مع تذكيرات التلاوة اليومية.';

  @override
  String get permissionNotifDenied => 'تم رفض إذن الإشعارات';

  @override
  String get permissionOverlayTitle => 'الظهور فوق التطبيقات';

  @override
  String get permissionOverlayBody =>
      'مطلوب لإظهار شاشة القفل فوق التطبيقات الأخرى.';

  @override
  String get permissionOverlayOpenSettings => 'تفعيل الظهور';

  @override
  String get permissionOverlayNotAvailable =>
      'الظهور فوق التطبيقات غير متاح على هذا الجهاز';

  @override
  String get permissionStatusGranted => 'مسموح';

  @override
  String get permissionStatusDenied => 'مرفوض';

  @override
  String get permissionStatusNotAvailable => 'غير متاح';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingGrantPermission => 'منح الإذن';

  @override
  String get onboardingOpenSettings => 'فتح الإعدادات';

  @override
  String get onboardingContinue => 'متابعة';

  @override
  String get onboardingDone => 'تم';

  @override
  String get quranSurahListTitle => 'القرآن الكريم';

  @override
  String get quranSearchPlaceholder => 'ابحث عن سورة...';

  @override
  String get quranMeccan => 'مكية';

  @override
  String get quranMedinan => 'مدنية';

  @override
  String quranAyahCount(int count) {
    return '$count آيات';
  }

  @override
  String quranSurahNumber(int number) {
    return 'سورة رقم $number';
  }

  @override
  String get quranLoading => 'جاري تحميل القرآن...';

  @override
  String get quranLoadError => 'فشل تحميل بيانات القرآن';

  @override
  String get quranRetry => 'إعادة المحاولة';

  @override
  String get quranOfflineBanner =>
      'أنت غير متصل بالإنترنت. يتم عرض البيانات المخزنة.';

  @override
  String get quranOfflineError =>
      'أنت غير متصل بالإنترنت ولا توجد بيانات مخزنة متاحة.';

  @override
  String get quranSurahDetailTitle => 'تفاصيل السورة';

  @override
  String get quranAssignAyah => 'تعيين كهدف';

  @override
  String get quranAyahAssigned => 'تم تعيين الآية بنجاح!';

  @override
  String get quranTranslation => 'الترجمة';

  @override
  String get quranAyahSearchTitle => 'بحث في الآيات';

  @override
  String get quranAyahSearchPlaceholder => 'أدخل كلمة بحث...';

  @override
  String get quranAyahSearchNoResults => 'لم يتم العثور على آيات لهذه الكلمة';

  @override
  String get quranBrowseBySurah => 'تصفح حسب السورة';

  @override
  String get quranAssignmentTitle => 'الآية المستهدفة';

  @override
  String get quranAssignmentNone => 'لم يتم تعيين آية مستهدفة';

  @override
  String get quranAssignmentClear => 'مسح الهدف';

  @override
  String get quranAssignmentConfirm => 'هل تريد مسح هذا التعيين؟';

  @override
  String get errorGeneric => 'حدث خطأ ما';

  @override
  String get errorNetwork => 'خطأ في الشبكة، تحقق من الاتصال';

  @override
  String get errorMicUnavailable => 'الميكروفون غير متاح';

  @override
  String get errorOffline => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorApiTimeout => 'انتهت مهلة الطلب';

  @override
  String get errorNotFound => 'المورد غير موجود';

  @override
  String get motivational1 => 'استمر! أنت تبلي بلاءً حسناً.';

  @override
  String get motivational2 => 'بكل حرف حسنة.';

  @override
  String get motivational3 => 'الاستمرار هو المفتاح.';

  @override
  String get motivational4 => 'تواصل مع القرآن يومياً.';

  @override
  String get motivational5 => 'بارك الله في جهودك.';

  @override
  String get saveButton => 'حفظ';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get confirmButton => 'تأكيد';

  @override
  String get backButton => 'رجوع';

  @override
  String get openSettingsButton => 'الإعدادات';

  @override
  String get grantButton => 'منح';

  @override
  String get manageButton => 'إدارة';

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String get searchButton => 'بحث';
}
