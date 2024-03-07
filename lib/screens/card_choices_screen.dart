import 'package:adan_russia/constatnts.dart';
import 'package:adan_russia/utils/utils_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CardChoices extends StatefulWidget {
  const CardChoices({super.key});

  @override
  _CardChoicesState createState() => _CardChoicesState();
}

class _CardChoicesState extends State<CardChoices> {
  int selectedCardIndex = -1;

  List<String> cardTitles = [
    "dubai",
    'egyptian',
    'karachi',
    'kuwait',
    'moon_sighting_committee',
    'muslim_world_league',
    'north_america',
    'qatar',
    'tehran',
    'turkey',
    'umm_al_qura',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // childAspectRatio: 0.9,
        // mainAxisExtent: 150,
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
      ),
      itemCount: cardTitles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            selectedCardIndex = index;
            EasyLoading.show(status: 'loading'.tr);
            setCalculationMethod(cardTitles[selectedCardIndex]);
            EasyLoading.showSuccess('done'.tr);
            EasyLoading.dismiss();
            setState(() {
              Get.back();
              // Navigator.of(context).pop();
            });
          },
          child: Card(
            color: selectedCardIndex == index ? Colors.blue : MAIN_COLOR,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  cardTitles[index].tr,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                    color: selectedCardIndex == index
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
