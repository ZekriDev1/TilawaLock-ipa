class RecitationAssignmentModel {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String arabicText;
  final String translationText;
  final String? audioUrl;
  final DateTime assignedAt;

  RecitationAssignmentModel({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.arabicText,
    required this.translationText,
    this.audioUrl,
    required this.assignedAt,
  });

  factory RecitationAssignmentModel.fromJson(Map<String, dynamic> json) {
    return RecitationAssignmentModel(
      surahNumber: json['surahNumber'],
      surahName: json['surahName'],
      ayahNumber: json['ayahNumber'],
      arabicText: json['arabicText'],
      translationText: json['translationText'],
      audioUrl: json['audioUrl'],
      assignedAt: DateTime.parse(json['assignedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'arabicText': arabicText,
      'translationText': translationText,
      'audioUrl': audioUrl,
      'assignedAt': assignedAt.toIso8601String(),
    };
  }
}
