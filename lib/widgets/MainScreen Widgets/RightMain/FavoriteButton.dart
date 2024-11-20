import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:weatherapp/screens/mainScreems/NavigationMenu.dart';

import '../../../controllers/FavCountryController.dart';
import '../../../controllers/weathrControllers/WeatherController.dart';
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.currentTheme,
    required this.weatherController,
    required this.favCountryController,
    required this.sortOption,
    required this.isNight,
  });

  final ThemeData currentTheme;
  final WeatherController weatherController;
  final WeatherController favCountryController;
  final RxString sortOption;
  final bool isNight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.12,
      height: Get.height * 0.06,
      decoration: BoxDecoration(
          color: currentTheme.cardColor,
          border: Border.all(
            width: 2,
            color: currentTheme.primaryColorLight,
          ),
          borderRadius: BorderRadius.circular(13)),
      child: IconButton(
          onPressed: () async {
            EasyLoading.show();
            EasyLoading.dismiss();
            Get.offAll(
                () => NavigationMenu(city: sortOption.value, selectedIndex: 1,),transition: Transition.rightToLeftWithFade);
          },
          icon: Icon(
            Iconsax.heart_add,
            size: 20,
            color: currentTheme.highlightColor,
          )),
    );
  }
}