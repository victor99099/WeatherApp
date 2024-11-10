import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/GlobalFunctions.dart';
import '../../../controllers/UserDataaController.dart';
import '../../../controllers/weathrControllers/WeatherController.dart';
import '../../../controllers/weathrControllers/coordinates.dart';
import '../../../controllers/weathrControllers/dateTime.dart';
import '../../../models/weatherModel.dart';
import '../../../screens/mainScreems/mainScreen.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu(
      {super.key,
      required this.currentTheme,
      required this.sortOption,
      required this.isNight});
  final ThemeData currentTheme;
  final RxString sortOption;
  final bool isNight;

  @override
  Widget build(BuildContext context) {
     WeatherController weatherController =
                  Get.put(WeatherController());
    CoordinatesController coordinatesController =
                  Get.put(CoordinatesController());
    final UserController userController = Get.find<UserController>();

    List<String> cities = userController.user.value!.favorites;
    print(cities);
    return Container(
      // color: currentTheme.cardColor,
      width: Get.width * 0.35,
      height: Get.height * 0.06,
      child: Obx(() {
        return DropdownButtonFormField<String>(
          borderRadius: BorderRadius.circular(25),
          padding: EdgeInsets.all(0),

          style: TextStyle(color: currentTheme.primaryColorDark, fontSize: 14),
          dropdownColor: currentTheme.cardColor,
          icon: Icon(
            Iconsax.arrow_down5,
            color: currentTheme.primaryColorDark,
          ),
          isDense: true,
          iconSize: 10,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.only(left: 219,right: 20,bottom: 10),
          decoration: InputDecoration(
            focusColor: currentTheme.cardColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: currentTheme
                    .primaryColorLight, // Custom color for the bottom line when enabled
                width: 2.0, // Thickness of the bottom line
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: currentTheme
                    .primaryColorLight, // Custom color for the bottom line when focused
                width: 2.0, // Thickness of the bottom line
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors
                    .red, // Custom color for the bottom line when there's an error
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            fillColor: currentTheme.cardColor,
          ),
          value: sortOption.value,
          items: cities
              .map((option) => DropdownMenuItem<String>(
                    child: Text(option),
                    value: option,
                  ))
              .toList(),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              sortOption.value = newValue;

              EasyLoading.show();

              
              Coord coord =
                  await coordinatesController.fetchcoord(sortOption.value);
              DateTimeController dateTimeController =
                  await Get.put(DateTimeController(sortOption.value));
              await dateTimeController.getDateTimeOfCity(coord);
              final currentdatetime =
                  dateTimeController.getCurrentDateTime(coord);
              final isNight = updateCurrentTime(currentdatetime);
             
              final List<WeatherModel> weatherData =
                  await weatherController.getWeatherData(sortOption.value);

              EasyLoading.dismiss();
              Get.offAll(() => MainScreen(
                isNight: isNight,
                    dateTimeController: dateTimeController,
                    weatherData: weatherData,
                    coord: coord,
                    city: sortOption.value,
                  ));
            }
          },
        );
      }),
    );
  }


}
