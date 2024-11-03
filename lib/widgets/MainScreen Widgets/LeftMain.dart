import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/weathrControllers/coordinates.dart';
import '../../controllers/weathrControllers/dateTime.dart';
import '../../models/weatherModel.dart';

class LeftMain extends StatelessWidget {
  const LeftMain({
    super.key,
    required this.currentdatetime,
    required this.todayWeather,
    required this.coord,
  });

  final currentDateTime currentdatetime;
  final WeatherModel todayWeather;
  final Coord coord;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.41,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            currentdatetime.time,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white),
          ),
          Text(
            currentdatetime.date,
            style: TextStyle(
                fontSize: 12,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white),
          ).pOnly(left: Get.width * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(todayWeather.temperature.toStringAsFixed(0) + "°C",
                      style: TextStyle(
                          fontSize: 33,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.white))
                  .pOnly(top: Get.width * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "H : ${coord.lon.toStringAsFixed(0)}°",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.white),
                  ),
                  Text(
                    "L : ${coord.lat.toStringAsFixed(0)}°",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.white),
                  )
                ],
              ).pOnly(right: 10)
            ],
          ).pOnly(top: Get.width * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                todayWeather.description.capitalized,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: Colors.white),
              ),
              Icon(
                Iconsax.cloud,
                color: Colors.white,
                size: 18,
              ).pOnly(left: Get.width * 0.01)
            ],
          ),
          Text(
            "Feels Like",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white),
          ).pOnly(top: Get.width * 0.03),
          Text(
            todayWeather.feelsLike.toStringAsFixed(0) + " °C",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white),
          )
        ],
      ).marginOnly(top: Get.height * 0.08, left: Get.width * 0.03),
    );
  }
}
