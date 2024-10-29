import 'package:flutter/material.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:weatherapp/screens/AuthScreens/intro.dart';
import 'package:get/get.dart';
import 'utils/Themes.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() {
  tz.initializeTimeZones();
  Get.put(UserController());
  runApp(const MyApp());
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
      
      home: IntroScreen(),
    );
  }
}

