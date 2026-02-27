class ApiConstants {
  static const String baseUrl = 'https://api.alquran.cloud/v1';
  
  static const String surahEndpoint = '$baseUrl/surah';
  static String singleSurahEndpoint(int number) => '$surahEndpoint/$number';
  static String surahWithEditionEndpoint(int number, String edition) => '$surahEndpoint/$number/$edition';
  static String surahEditionsEndpoint(int number, List<String> editions) => '$surahEndpoint/$number/editions/${editions.join(',')}';
  
  static String singleAyahEndpoint(int surah, int ayah) => '$baseUrl/ayah/$surah:$ayah';
  static String ayahWithEditionEndpoint(int surah, int ayah, String edition) => '$baseUrl/ayah/$surah:$ayah/$edition';
  
  static String searchEndpoint(String keyword, {String surah = 'all', String language = 'en'}) => 
      '$baseUrl/search/$keyword/$surah/$language';
  
  static const String editionEndpoint = '$baseUrl/edition';
  static String juzEndpoint(int number, String edition) => '$baseUrl/juz/$number/$edition';
}
