import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_task/controller/surah_controller.dart';
import 'package:flutter_application_task/models/surah_model.dart';

class SurahView extends StatelessWidget {
  const SurahView({super.key});

  @override
  Widget build(BuildContext context) {
    final SurahController controller = Get.put(SurahController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Quran Surah Fetch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final selectedSurah = controller.selectedSurah.value;
        if (selectedSurah == null || controller.ayahs.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }

        final startIndex =
            controller.currentPage.value * controller.ayahsPerPage;
        final endIndex =
            (startIndex + controller.ayahsPerPage) > controller.ayahs.length
                ? controller.ayahs.length
                : startIndex + controller.ayahsPerPage;

        //DATA START & END CONDITION
        final validStartIndex = startIndex < 0 ? 0 : startIndex;
        final validEndIndex = endIndex > controller.ayahs.length
            ? controller.ayahs.length
            : endIndex;

        return Column(
          children: [
            DropdownButton<Surahs>(
              menuMaxHeight: 500,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              elevation: 20,
              value: selectedSurah,
              onChanged: (Surahs? newSurah) {
                if (newSurah != null) {
                  controller.onSurahChanged(newSurah);
                }
              },
              items: controller.surahs.map((Surahs surah) {
                return DropdownMenuItem<Surahs>(
                  value: surah,
                  child: Text(
                    surah.name ?? 'Null',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: validEndIndex - validStartIndex,
                itemBuilder: (context, index) {
                  final ayah = controller.ayahs[validStartIndex + index];
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    title: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 300, maxHeight: 200),
                      child: Text(
                        'Ayah ${ayah.number.toString()} \n ${ayah.text}',
                        style: const TextStyle(color: Colors.blue),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Number in Surah: ${ayah.numberInSurah?.toString()}'),
                        Text('Juz: ${ayah.juz.toString()}'),
                        Text('Manzil: ${ayah.manzil.toString()}'),
                        Text('Page: ${ayah.page.toString()}'),
                        Text('Ruku: ${ayah.ruku.toString()}'),
                        Text('Hizb Quarter: ${ayah.hizbQuarter.toString()}'),
                        Text('Sajda: ${ayah.sajda.toString()}'),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.black,
                    elevation: 8,
                  ),
                  onPressed: () {
                    controller.previousPage();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Previous',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.black,
                    elevation: 8,
                  ),
                  onPressed: () {
                    controller.nextAyah();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(width: 8.0),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      }),
    );
  }
}
