import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/FavCountryController.dart';
import '../../controllers/weathrControllers/WeatherController.dart';
import '../../models/weatherModel.dart';
import 'RightMain/DropDownMenu.dart';
import 'RightMain/FavoriteButton.dart';
import 'RightMain/SunriseAndSunset.dart';

class RightMain extends StatelessWidget {
  const RightMain({
    super.key,
    required this.isNight,
    required this.currentTheme,
    required this.sortOption,
    required this.todayWeather,
    required this.favCountryController
  });

  final ThemeData currentTheme;
  final RxString sortOption;
  final bool isNight;
  final WeatherModel todayWeather;
  final WeatherController favCountryController;

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
            FavoriteButton(currentTheme: currentTheme, weatherController: weatherController, favCountryController: favCountryController, sortOption: sortOption, isNight: isNight).marginOnly( top :Get.height * 0.1, left: Get.width * 0.01)
          ],
        ),
        SizedBox(
          width: Get.width * 0.3,
          height: Get.height * 0.2,
          child: Column(
            children: [
              Sunriseset(
                text: "Sunrise",
                sun: todayWeather.sunrise,
                icon: const Icon(CupertinoIcons.sunrise),
              ),
              20.heightBox,
              Sunriseset(
                  text: "Sunset",
                  sun: todayWeather.sunset,
                  icon: const Icon(CupertinoIcons.sunset)),
            ],
          ),
        ).marginOnly(left: Get.width * 0.11, top: 40)
      ],
    );
  }
}

