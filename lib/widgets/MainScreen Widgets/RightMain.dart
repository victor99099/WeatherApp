import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/FavCountryController.dart';
import '../../controllers/weathrControllers/WeatherController.dart';
import '../../models/weatherModel.dart';
import '../../screens/mainScreems/FavoritesScreen.dart';
import '../../screens/mainScreems/mainScreen.dart';
import 'RightMain/DropDownMenu.dart';
import 'RightMain/SunriseAndSunset.dart';

class RightMain extends StatelessWidget {
  const RightMain({
    super.key,
    required this.isNight,
    required this.currentTheme,
    required this.sortOption,
    required this.widget,
    required this.todayWeather,
    required this.favCountryController
  });

  final ThemeData currentTheme;
  final RxString sortOption;
  final bool isNight;
  final MainScreen widget;
  final WeatherModel todayWeather;
  final FavCountryController favCountryController;

  @override
  Widget build(BuildContext context) {
    WeatherController weatherController = Get.put(WeatherController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropDownMenu(currentTheme: currentTheme, sortOption: sortOption, isNight: isNight,)
                .marginOnly(top: Get.height * 0.1, left: Get.width * 0.09),
            Container(
              width: Get.width * 0.12,
              height: Get.height * 0.055,
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
                    List<WeatherModel> FavWeatherList =
                        await weatherController.getFavWeatherData();
                    await favCountryController.fetchCountries();
                    List<String> favCountryList = favCountryController.getFavCounties();
                    EasyLoading.dismiss();
                    Get.to(
                        () => FavoritesScreen(favWeatherList: FavWeatherList, favCountryList:favCountryList,sortOption: sortOption,isNight: isNight,));
                  },
                  icon: Icon(
                    Iconsax.heart_add,
                    size: 20,
                    color: currentTheme.highlightColor,
                  )),
            ).marginOnly(top: 73, left: Get.width * 0.01)
          ],
        ),
        Container(
          width: Get.width * 0.3,
          height: Get.height * 0.2,
          child: Column(
            children: [
              Sunriseset(
                text: "Sunrise",
                sun: todayWeather.sunrise,
                icon: Icon(CupertinoIcons.sunrise),
              ),
              20.heightBox,
              Sunriseset(
                  text: "Sunset",
                  sun: todayWeather.sunset,
                  icon: Icon(CupertinoIcons.sunset)),
            ],
          ),
        ).marginOnly(left: Get.width * 0.11, top: 40)
      ],
    );
  }
}