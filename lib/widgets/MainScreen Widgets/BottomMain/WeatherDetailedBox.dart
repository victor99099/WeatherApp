import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherDetailBox extends StatelessWidget {
  const WeatherDetailBox({
    super.key,
    required this.currentTheme,
    required this.todayWeather,
    required this.name,
  });

  final ThemeData currentTheme;
  final String todayWeather;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Center(
        child: Column(
          children: [
            getIconWeatherDetail(name, context),
            5.heightBox,
            Text(
              todayWeather,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: currentTheme.primaryColorDark),
            ),
            5.heightBox,
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: currentTheme.primaryColorLight),
            )
          ],
        ),
      ),
    );
  }
}

Icon getIconWeatherDetail(String name, BuildContext context) {
  const double iconSize = 16.0; // Set icon size to 16
  final currentTheme = Theme.of(context);
  switch (name.toLowerCase()) {
    case "humidity":
      return Icon(
        Icons.water_outlined,
        color: currentTheme.primaryColorLight.withOpacity(0.5),
        size: 70,
      );
    case "wind speed":
      return Icon(
        Icons.air,
        color: currentTheme.primaryColorLight.withOpacity(0.5),
        size: 70,
      );
    case "pressure":
      return Icon(
        Ionicons.md_speedometer_outline,
        color: currentTheme.primaryColorLight.withOpacity(0.5),
        size: 70,
      );

    default:
      return Icon(WeatherIcons.na,
          color: Colors.black, size: iconSize); // icon for undefined weather
  }
}
