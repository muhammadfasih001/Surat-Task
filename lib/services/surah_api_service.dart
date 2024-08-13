import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';

class ApiService {
  final String _baseUrl = 'https://api.alquran.cloud/v1';

  Future<SurahModel> fetchSurahs() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/quran/ur.jhaladhry'));
      if (response.statusCode == 200) {
        return SurahModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load surahs. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching surahs: $e');
      throw Exception('Failed to load surahs');
    }
  }

  Future<Surahs> fetchAyahs(int surahNumber) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/surah/$surahNumber'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Surahs.fromJson(data['data']); //index problem issue
      } else {
        throw Exception(
            'Failed to load ayahs. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ayahs for surah $surahNumber: $e');
      throw Exception('Failed to load ayahs');
    }
  }
}
