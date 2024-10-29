import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:weatherapp/screens/AuthScreens/SignInScreen.dart';

import '../../widgets/General/MainButton.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Container(
      height: Get.height*0.7,
      width : Get.width,
      color: currentTheme.canvasColor,
      child: Column(
        children: [
          Stack(
            children: [
              Material(
                elevation: 5,
                shadowColor: currentTheme.primaryColorDark,
                child: Container(
                  width: Get.width,
                  height: Get.height*0.65,
                  color: Colors.white.withOpacity(0.9),
                  child: Image.asset("assets/IntroMobile.png", fit: BoxFit.cover,),
                  // child: Image.network(
                  //     "http://localhost:3000/avatar/avatar/IntroMobile.png")4
                ),
              ),
            ],
          ),
          Center(
                  child: Text("Explore The App",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color: currentTheme.primaryColorDark,
                          fontFamily: GoogleFonts.poppins().fontFamily)))
              .marginOnly(top: 20),
          Text(
            "Welcome to your personalized weather app! Instantly get real-time weather updates and a 5-day forecast for any city. Stay informed with detailed information on temperature, weather conditions, and more, all beautifully displayed with dynamic day and night modes. Let's explore the weather together!",
            style: TextStyle(
                color: currentTheme.primaryColor,
                fontSize: 11,
                fontFamily: GoogleFonts.poppins().fontFamily,
                decoration: TextDecoration.none),
            textAlign: TextAlign.justify,
          ).marginAll(10).paddingOnly(left: 15, right: 15),
          MainButton(currentTheme: currentTheme,text: "Lets Start", onTap: (){ Get.to(()=>LogInScreen());},).marginOnly(top: 15)
        ],
      ),
    );
  }
}


