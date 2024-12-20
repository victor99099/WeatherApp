import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../../controllers/weathrControllers/coordinates.dart';
import '../../../controllers/weathrControllers/dateTime.dart';
import '../../../models/weatherModel.dart';

class ForecastList extends StatelessWidget {
  const ForecastList(
      {super.key,
      required this.forecast,
      required this.currentTheme,
      required this.sortOption,
      required this.coord});

  final List<WeatherModel> forecast;
  final ThemeData currentTheme;
  final RxString sortOption;
  final Coord coord;

  @override
  Widget build(BuildContext context) {
    DateTimeController dateTimeController =
        Get.put(DateTimeController(sortOption.value));
    return Container(
      // height: Get.height * 0.5,
      child: ListView.builder(
          itemCount: (forecast.length),
          padding: EdgeInsets.only(top: 8, left: (Get.width * 0.13)),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            currentDateTime dateTime =
                dateTimeController.getDateTime(index + 1, coord);
            return Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width * 0.125,
                    child: Text(
                      dateTime.date,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: currentTheme.primaryColorDark),
                    ).pOnly(bottom: 8),
                  ),
                  SizedBox(
                    width: Get.width * 0.5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: Get.width * 0.03,
                            child: getIcon(forecast[index].description)),
                        20.widthBox,
                        SizedBox(
                          width: Get.width * 0.3,
                          child: Text(
                            forecast[index].description,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: currentTheme.primaryColorDark),
                          ).pOnly(bottom: 8),
                        ),
                      ],
                    ).pOnly(left: 20),
                  ),
                  Text(
                    "${forecast[index].temperature.toStringAsFixed(0)}/${forecast[index].feelsLike.toStringAsFixed(0)}°",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: currentTheme.primaryColorDark),
                  )
                ],
              ).pOnly(top: 10),
            );
          }),
    );
  }
}

Icon getIcon(String desc) {
  const double iconSize = 16.0; // Set icon size to 16

  switch (desc.toLowerCase()) {
    case "clear sky":
    case "sunny":
    case "mostly clear":
      return const Icon(WeatherIcons.day_sunny, color: Colors.orange, size: iconSize);

    case "partly cloudy":
    case "scattered clouds":
    case "few clouds":
      return const Icon(WeatherIcons.day_cloudy,
          color: Colors.blueGrey, size: iconSize);

    case "overcast clouds":
    case "mostly cloudy":
    case "broken clouds":
      return const Icon(WeatherIcons.cloudy, color: Colors.grey, size: iconSize);

    case "light rain":
    case "drizzle":
      return const Icon(WeatherIcons.raindrop,
          color: Colors.lightBlueAccent, size: iconSize);

    case "moderate rain":
    case "heavy rain":
    case "showers":
    case "light shower rain":
      return const Icon(WeatherIcons.rain, color: Colors.blue, size: iconSize);

    case "thunderstorm":
    case "thunderstorm with rain":
    case "thunderstorm with light rain":
    case "thunderstorm with heavy rain":
      return const Icon(WeatherIcons.thunderstorm,
          color: Colors.deepPurple, size: iconSize);

    case "snow":
    case "light snow":
    case "snow showers":
    case "heavy snow":
      return const Icon(WeatherIcons.snow, color: Colors.lightBlue, size: iconSize);

    case "mist":
    case "fog":
    case "haze":
      return const Icon(WeatherIcons.fog, color: Colors.grey, size: iconSize);

    case "dust":
    case "sandstorm":
      return const Icon(WeatherIcons.sandstorm, color: Colors.brown, size: iconSize);

    case "smoke":
      return const Icon(WeatherIcons.smoke, color: Colors.grey, size: iconSize);

    default:
      return const Icon(WeatherIcons.na,
          color: Colors.black, size: iconSize); // icon for undefined weather
  }
}
