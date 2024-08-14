import 'package:flutter/material.dart';
import 'package:flutter_application_task/services/surah_api_service.dart';
import 'package:get/get.dart';
import '../models/surah_model.dart';

class SurahController extends GetxController {
  final ApiService apiService = ApiService();

  var surahs = <Surahs>[].obs;
  var selectedSurah = Rxn<Surahs>();
  var ayahs = <Ayahs>[].obs;
  var currentPage = 0.obs;
  final int ayahsPerPage = 9;

  @override
  void onInit() {
    super.onInit();
    loadSurahs();
  }

  Future<void> loadSurahs() async {
    try {
      final surahModel = await apiService.fetchSurahs();
      surahs.value = surahModel.data?.surahs ?? [];

      if (surahs.isNotEmpty) {
        selectedSurah.value = surahs.first;

        await loadAyahs(surahs.first.number!);
      }
    } catch (e) {
      print('Error loading surahs: $e');
    }
  }

  Future<void> loadAyahs(int surahNumber) async {
    try {
      final surah = await apiService.fetchAyahs(surahNumber);
      ayahs.value = surah.ayahs ?? [];
      currentPage.value = 0;
    } catch (e) {
      print('Error loading ayahs: $e');
    }
  }

  void onSurahChanged(Surahs surah) {
    selectedSurah.value = surah;
    loadAyahs(surah.number!);
  }

  void nextAyah() {
    if ((currentPage.value + 1) * ayahsPerPage < ayahs.length) {
      currentPage.value++;
    } else {
      var currentSurahIndex = surahs.indexOf(selectedSurah.value!);
      if (currentSurahIndex < surahs.length - 1) {
        onSurahChanged(surahs[currentSurahIndex + 1]);
      }
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    } else {
      var currentSurahIndex = surahs.indexOf(selectedSurah.value!);
      if (currentSurahIndex > 0) {
        onSurahChanged(surahs[currentSurahIndex - 1]);
      }
    }
  }
}
