import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/controllers/SiginControllers/verifyController.dart';
import 'package:weatherapp/screens/AuthScreens/SignInScreen.dart';
import 'package:weatherapp/widgets/Auth%20Widgets/NotAndALreadySigned.dart';
import 'package:weatherapp/widgets/General/MainButton.dart';
import '../../widgets/Auth Widgets/VerifyCodeFields.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers =
        List.generate(6, (index) => TextEditingController());
    List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

    final currentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentTheme.canvasColor,
      ),
      body: Container(
        color: currentTheme.canvasColor,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verification code",
              style: TextStyle(
                  color: currentTheme.primaryColorDark,
                  decoration: TextDecoration.none,
                  fontSize: 22,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold),
            ).marginOnly(top: 10, left: 28),
            Container(
              width: Get.width * 0.75,
              child: Text("We have sent the verification code to your email",
                      style: TextStyle(
                          color: currentTheme.primaryColorLight,
                          decoration: TextDecoration.none,
                          fontSize: 14,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold))
                  .marginOnly(top: 10, left: 28),
            ),
            VerifyCodeFields(controllers: controllers, focusNodes: focusNodes)
                .pOnly(top: 20, left: 10, right: 10),
            NotAndAlreadySigned(
                    currentTheme: currentTheme,
                    onTap: () {
                      VerifyController verifyController =
                          Get.put(VerifyController());
                      verifyController.resendCode();
                    },
                    firstText: "Didn't recieve OPT code ? ",
                    seconfText: "Resend code")
                .marginOnly(right: 48, top: 20),
            MainButton(
                    currentTheme: currentTheme,
                    onTap: () async {
                      VerifyController verifyController =
                          Get.put(VerifyController());
                      print('pressed');
                      final value =
                          "${controllers[0].text}${controllers[1].text}${controllers[2].text}${controllers[3].text}${controllers[4].text}${controllers[5].text}";

                      if (value.length < 6) {
                        Get.snackbar(
                            'Error', "Please fill full four digit code",
                            snackPosition: SnackPosition.BOTTOM);
                      } else {
                        final check = await verifyController.verify(value);
                        if (check) {
                          Get.to(() => LogInScreen());
                        } 
                      }
                    },
                    text: "Confirm")
                .pOnly(top: 40, left: 20, right: 20)
          ],
        ),
      ),
    );
  }
}
