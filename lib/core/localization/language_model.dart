class LanguageModel {
  final String code;
  final String name;
  final String nativeName;
  final bool isRTL;
  final String fontFamily;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
    this.isRTL = false,
    required this.fontFamily,
  });
}
