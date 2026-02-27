class AyahModel {
  final int number;
  final int numberInSurah;
  final String text;
  final int surahNumber;
  final String? audioUrl;
  final int juz;
  final int page;
  final bool? sajda;

  AyahModel({
    required this.number,
    required this.numberInSurah,
    required this.text,
    required this.surahNumber,
    this.audioUrl,
    required this.juz,
    required this.page,
    this.sajda,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json, {int? surahNum}) {
    return AyahModel(
      number: json['number'],
      numberInSurah: json['numberInSurah'],
      text: json['text'],
      surahNumber: surahNum ?? (json['surah'] != null ? json['surah']['number'] : 0),
      audioUrl: json['audio'],
      juz: json['juz'],
      page: json['page'],
      sajda: json['sajda'] is bool ? json['sajda'] : (json['sajda'] != null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'numberInSurah': numberInSurah,
      'text': text,
      'surahNumber': surahNumber,
      'audio': audioUrl,
      'juz': juz,
      'page': page,
      'sajda': sajda,
    };
  }
}
