import 'package:flutter/material.dart';
import 'package:flutter_application_task/constant/appcolor/app_color.dart';
import 'package:get/get.dart';
import 'package:flutter_application_task/controller/surah_controller.dart';
import 'package:flutter_application_task/models/surah_model.dart';

class SurahView extends StatelessWidget {
  const SurahView({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textd = const TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );
    final SurahController controller = Get.put(SurahController());

    return Scaffold(
      backgroundColor: AppColor.surahpagebgcolor,
      // backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: AppColor.appbarcolor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_outlined,
              color: Colors.purple,
            ),
          ),
        ],
        title: const Text(
          'QURAN',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final selectedSurah = controller.selectedSurah.value;
        if (selectedSurah == null || controller.ayahs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
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
            const SizedBox(
              height: 20,
            ),
            DropdownButton<Surahs>(
              // focusColor: Colors.amber,

              borderRadius: BorderRadius.circular(10),
              elevation: 1,
              padding: const EdgeInsets.all(5),
              iconEnabledColor: Colors.purple,
              iconDisabledColor: Colors.black,
              iconSize: 35,
              dropdownColor: Colors.purple.shade50,

              menuMaxHeight: 450,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              value: selectedSurah,
              onChanged: (Surahs? newSurah) {
                if (newSurah != null) {
                  controller.onSurahChanged(newSurah);
                }
              },
              items: controller.surahs.map((Surahs surah) {
                return DropdownMenuItem<Surahs>(
                  alignment: Alignment.centerRight,
                  value: surah,
                  child: Text(
                    style: const TextStyle(color: Colors.black),
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    title: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 100, maxHeight: 280),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            width: 135,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.purple.shade50,
                            ),
                            child: Center(
                              child: Text(
                                'Ayah : ${ayah.number.toString()}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            '${ayah.text}',
                            style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Number in Surah: ${ayah.numberInSurah?.toString()}',
                          style: textd,
                        ),
                        Text(
                          'Juz: ${ayah.juz.toString()}',
                          style: textd,
                        ),
                        Text(
                          'Manzil: ${ayah.manzil.toString()}',
                          style: textd,
                        ),
                        Text(
                          'Page: ${ayah.page.toString()}',
                          style: textd,
                        ),
                        Text(
                          'Ruku: ${ayah.ruku.toString()}',
                          style: textd,
                        ),
                        Text(
                          'Hizb Quarter: ${ayah.hizbQuarter.toString()}',
                          style: textd,
                        ),
                        Text(
                          'Sajda: ${ayah.sajda.toString()}',
                          style: textd,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    backgroundColor: Colors.purple.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    controller.previousPage();
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_left_outlined,
                    color: Colors.purple,
                    size: 30,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    backgroundColor: Colors.purple.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.black,
                  ),
                  onPressed: () {
                    controller.nextAyah();
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: Colors.purple,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        );
      }),
    );
  }
}
