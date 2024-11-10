import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:weatherapp/screens/AuthScreens/SplashScreen.dart';
import 'package:get/get.dart';
import 'utils/Themes.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() {
  tz.initializeTimeZones();
  Get.put(UserController());
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
    
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      title: 'Weather Guy',
       builder: EasyLoading.init(),
      home: const Splashscreen(),
    );
  }
}

