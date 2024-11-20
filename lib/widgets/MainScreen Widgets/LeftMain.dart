import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/controllers/UnitController.dart';

import '../../controllers/weathrControllers/coordinates.dart';
import '../../controllers/weathrControllers/dateTime.dart';
import '../../models/weatherModel.dart';

class LeftMain extends StatelessWidget {
  LeftMain({
    super.key,
    required this.currentdatetime,
    required this.todayWeather,
    required this.coord,
  });

  final currentDateTime currentdatetime;
  final WeatherModel todayWeather;
  final Coord coord;

  final UnitController unitController = Get.put(UnitController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => SizedBox(
                  child: Text( unitController.selectedValue.value == 1 ?
                          "${todayWeather.temperature.toStringAsFixed(0)}°C" : "${(((todayWeather.temperature)*9/5)+32).toStringAsFixed(0)}°F",
                          style: TextStyle(
                              fontSize: 33,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.white))
                      .pOnly(top: Get.width * 0.01),
                ),
              ),
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
              ).pOnly(left: 10)
            ],
          ).pOnly(top: Get.width * 0.02),
          SizedBox(
            width: Get.width * 0.3, // Total width of the parent
            child: Row(
              mainAxisSize: MainAxisSize
                  .min, // Makes the Row take only the space it needs
              children: [
                // Flexible widget ensures Text takes only as much width as it needs
                Flexible(
                  fit:
                      FlexFit.loose, // Text will occupy only the space it needs
                  child: Text(
                    todayWeather.description.capitalized,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Icon takes 20% of the width of the parent
                const Icon(
                  Iconsax.cloud,
                  color: Colors.white,
                  size: 18,
                ).pOnly(left: 10),
              ],
            ),
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
            unitController.selectedValue.value == 1 ?
                          "${todayWeather.feelsLike.toStringAsFixed(0)}°C" : "${(((todayWeather.feelsLike)*9/5)+32).toStringAsFixed(0)}°F",
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
