import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/controllers/SiginControllers/GoogleSignIn.dart';
import 'package:weatherapp/screens/AuthScreens/intro.dart';
import 'package:weatherapp/screens/mainScreems/UnitScreen.dart';

import '../../widgets/General/CustomDialog.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final GoogleAuthService googleAuthService = GoogleAuthService();

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: currentTheme.canvasColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // iconTheme: IconThemeData(color: currentTheme.primaryColorDark),
        backgroundColor: Colors.transparent,
        title: Text(
          "Settings",
          style: TextStyle(
              fontSize: 21,
              color: currentTheme.primaryColorDark,
              fontFamily: GoogleFonts.poppins().fontFamily),
        ),
      ),
      body: Column(
        children: [
          
          SettingOption(
              currentTheme: currentTheme,
              title: "Change Unit",
              upperWidth: 1,
              onTap: () {
                Get.to(()=>UnitScreen(), transition: Transition.rightToLeft);
              }),
          SettingOption(
            currentTheme: currentTheme,
            title: "Logout",
            upperWidth: 0,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                        title: "Logout",
                        content: "Are you sure ?",
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                        onConfirm: () async {
                          Navigator.of(context).pop();
                          googleAuthService.logout();
                          Get.offAll(() => const IntroScreen());
                        });
                  });
            },
          ),
        ],
      ).pOnly(top: Get.height * 0.03),
    );
  }
}

class SettingOption extends StatelessWidget {
  const SettingOption(
      {super.key,
      required this.currentTheme,
      required this.title,
      required this.upperWidth,
      required this.onTap});

  final ThemeData currentTheme;
  final String title;
  final double upperWidth;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: currentTheme.primaryColorLight, width: upperWidth),
          bottom: BorderSide(color: currentTheme.primaryColorLight, width: 1),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              color: currentTheme.primaryColor,
              fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        trailing: Text(
          ">",
          style: TextStyle(
              fontSize: 20,
              color: currentTheme.primaryColor,
              fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        onTap: onTap,
      ),
    );
  }
}
