import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/controllers/weathrControllers/coordinates.dart';
import 'package:weatherapp/controllers/weathrControllers/dateTime.dart';
import 'package:weatherapp/screens/mainScreems/mainScreen.dart';

import '../../controllers/SiginControllers/GoogleSignIn.dart';
import '../../controllers/UserDataaController.dart';
import '../../controllers/weathrControllers/WeatherController.dart';
import '../../models/weatherModel.dart';
import '../../screens/AuthScreens/intro.dart';

class GoogleAndFb extends StatelessWidget {
  const GoogleAndFb({
    super.key,
    required this.currentTheme,
  });

  final ThemeData currentTheme;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final GoogleAuthService authService = GoogleAuthService();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
            try {
              await authService.initiateGoogleSignIn(context);
              final user = userController.user.value;
              if (user != null) {
                print("username is : " + user.username);
                // This prints the username from the signed-in user
                CoordinatesController coordinatesController = Get.put(CoordinatesController());
                Coord coord = await coordinatesController.fetchcoord(user.favorites[0]); 
                 DateTimeController dateTimeController =
                  await Get.put(DateTimeController(user.favorites[0]));
              await dateTimeController.getDateTimeOfCity(coord);
                WeatherController weatherController =
                    await Get.put(WeatherController());
                final List<WeatherModel> weatherData = 
                    await 
                    weatherController.getWeatherData(user.favorites[0]);
                
                print(weatherData.length);
                Get.off(() => MainScreen(dateTimeController: dateTimeController,weatherData : weatherData, coord : coord, city: user.favorites[0],)); // Navigate to the intro screen
              }
            } catch (error) {
              print("Error Signing In: $error");
            }
          },
          child: Container(
            width: Get.width * 0.25,
            height: Get.height * 0.09,
            child: Card(
              elevation: 2,
              color: currentTheme.cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Image.asset(
                "assets/google.png",

              )
                  
            ),
          ),
        ),
        20.widthBox,
        Container(
          width: Get.width * 0.25,
          height: Get.height * 0.09,
          child: Card(
            elevation: 2,
            color: currentTheme.cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Image.asset(
              "assets/Fb.png",
              
            )
                
          ),
        ),
      ],
    );
  }
}
