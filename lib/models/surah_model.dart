import 'ayah_model.dart';

class SurahModel {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<AyahModel>? ayahs;

  SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    this.ayahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    var ayahsJson = json['ayahs'] as List?;
    List<AyahModel>? ayahsList = ayahsJson?.map((a) => AyahModel.fromJson(a, surahNum: json['number'])).toList();

    return SurahModel(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      ayahs: ayahsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'ayahs': ayahs?.map((a) => a.toJson()).toList(),
    };
  }
}
