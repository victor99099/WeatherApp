

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/controllers/weathrControllers/coordinates.dart';



import '../../models/weatherModel.dart';
import 'BottomMain/ForecastList.dart';
import 'BottomMain/HeadingDivider.dart';
import 'BottomMain/WeatherDetailedBox.dart';


class BottomMain extends StatelessWidget {
  const BottomMain({
    super.key,
    required this.currentTheme,
    required this.coord,
    required this.forecast,
    required this.sortOption,
    required this.todayWeather,
  });

  final ThemeData currentTheme;
  final Coord coord;
  final List<WeatherModel> forecast;
  final RxString sortOption;
  final WeatherModel todayWeather;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.73,
      decoration: BoxDecoration(
        color: currentTheme.canvasColor,
        border: Border.all(color: Colors.transparent, width: 2),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          MainScreenHeadingDivider(
            currentTheme: currentTheme,
            text: "7 Day Forecast",
          ),
          ForecastList(
            coord: coord,
            forecast: forecast,
            currentTheme: currentTheme,
            sortOption: sortOption,
          ),
          MainScreenHeadingDivider(
              currentTheme: currentTheme, text: "Weather Details"),
          SizedBox(
            height: Get.height * 0.45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WeatherDetailBox(
                  currentTheme: currentTheme,
                  todayWeather:
                      "${todayWeather.humidity.toStringAsFixed(0)}%",
                  name: "Humidity",
                ),
                WeatherDetailBox(
                    currentTheme: currentTheme,
                    todayWeather:
                        "${todayWeather.windSpeed.toStringAsFixed(0)}2Km/h",
                    name: "Wind Speed"),
                WeatherDetailBox(
                    currentTheme: currentTheme,
                    todayWeather:
                        "${todayWeather.pressure.toStringAsFixed(0)}2Km/h",
                    name: "Pressure"),
              ],
            ),
          ).pOnly(top: 10, bottom: Get.height*0.02)
        ]),
      ),
    );
  }
}