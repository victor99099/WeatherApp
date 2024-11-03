

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';



import '../../models/weatherModel.dart';
import '../../screens/mainScreems/mainScreen.dart';
import 'BottomMain/ForecastList.dart';
import 'BottomMain/HeadingDivider.dart';
import 'BottomMain/WeatherDetailedBox.dart';


class BottomMain extends StatelessWidget {
  const BottomMain({
    super.key,
    required this.currentTheme,
    required this.widget,
    required this.forecast,
    required this.sortOption,
    required this.todayWeather,
  });

  final ThemeData currentTheme;
  final MainScreen widget;
  final List<WeatherModel> forecast;
  final RxString sortOption;
  final WeatherModel todayWeather;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: Get.height * 0.4,
        child: Container(
          width: Get.width,
          height: Get.height * 0.63,
          decoration: BoxDecoration(
            color: currentTheme.canvasColor,
            border: Border.all(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35)),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              MainScreenHeadingDivider(
                currentTheme: currentTheme,
                text: "7 Day Forecast",
              ),
              ForecastList(
                coord: widget.coord,
                forecast: forecast,
                currentTheme: currentTheme,
                sortOption: sortOption,
              ),
              MainScreenHeadingDivider(
                  currentTheme: currentTheme, text: "Weather Details"),
              Container(
                height: Get.height * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    WeatherDetailBox(
                      currentTheme: currentTheme,
                      todayWeather:
                          todayWeather.humidity.toStringAsFixed(0) + "%",
                      name: "Humidity",
                    ),
                    WeatherDetailBox(
                        currentTheme: currentTheme,
                        todayWeather:
                            todayWeather.windSpeed.toStringAsFixed(0) +
                                "2Km/h",
                        name: "Wind Speed"),
                    WeatherDetailBox(
                        currentTheme: currentTheme,
                        todayWeather:
                            todayWeather.pressure.toStringAsFixed(0) +
                                "2Km/h",
                        name: "Pressure"),
                  ],
                ),
              ).pOnly(top: 10)
            ]),
          ),
        ));
  }
}