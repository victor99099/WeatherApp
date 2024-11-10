import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/screens/AuthScreens/SignInScreen.dart';
import 'package:weatherapp/screens/mainScreems/mainScreen.dart';

import '../../controllers/GlobalFunctions.dart';
import '../../controllers/UserDataaController.dart';
import '../../controllers/weathrControllers/WeatherController.dart';
import '../../controllers/weathrControllers/coordinates.dart';
import '../../controllers/weathrControllers/dateTime.dart';
import '../../models/weatherModel.dart';
import '../../utils/Themes.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  WeatherController weatherController = Get.put(WeatherController());
  CoordinatesController coordinatesController =
      Get.put(CoordinatesController());
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () {
      navigateBasedOnLoginStatus();
    });
  }

  Future<void> navigateBasedOnLoginStatus() async {
    bool isLoggedIn = await userController.checkLoginStatus();

    // Show loading dialog while waiting for login check if necessary
    if (userController.isLoading.value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final currentTheme = Theme.of(context);
          return Container(
            color: currentTheme.shadowColor,
            width: Get.width,
            height: Get.height,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: Colors.white),
                  SizedBox(height: 16),
                  Text("Logging in ...",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          );
        },
      );
    }

    // Navigate based on login status
    if (isLoggedIn) {
      final user = userController.user.value!;
      Coord coord = await coordinatesController.fetchcoord(user.favorites[0]);
      DateTimeController dateTimeController =
          Get.put(DateTimeController(user.favorites[0]));
      await dateTimeController.getDateTimeOfCity(coord);
      final List<WeatherModel> weatherData =
          await weatherController.getWeatherData(user.favorites[0]);
      final currentdatetime = dateTimeController.getCurrentDateTime(coord);
      final isNight = updateCurrentTime(currentdatetime);
      Get.offAll(() => MainScreen(
            weatherData: weatherData,
            coord: coord,
            dateTimeController: dateTimeController,
            isNight: isNight,
            city: user.favorites[0],
          ));
    } else {
      Get.offAll(() => LogInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final getTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: getTheme.shadowColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: Get.height * 0.9,
                width: Get.width,
                child: Lottie.asset("assets/loading.json",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain),
              ),
            ),
            Container(
              height: Get.height * 1 / 3,
              width: Get.width,
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 20),
              child: (AppConstant.AppPoweredBy)
                  .text
                  .xl
                  .textStyle(const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))
                  .make(),
            )
          ],
        ),
      ),
    );
  }
}
