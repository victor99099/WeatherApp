import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/controllers/SiginControllers/SignupController.dart';
import 'package:weatherapp/screens/AuthScreens/SignInScreen.dart';
import 'package:weatherapp/screens/AuthScreens/verificationScreen.dart';
import 'package:weatherapp/widgets/Auth%20Widgets/CityField.dart';
import 'package:weatherapp/widgets/Auth%20Widgets/Divider.dart';
import 'package:weatherapp/widgets/Auth%20Widgets/EmailField.dart';
import 'package:weatherapp/widgets/Auth%20Widgets/GoogleAndFbButtons.dart';
import 'package:weatherapp/widgets/Auth%20Widgets/Logo.dart';
import 'package:weatherapp/widgets/Auth%20Widgets/PassField.dart';
import 'package:weatherapp/widgets/Auth%20Widgets/UsernameField.dart';

import '../../widgets/Auth Widgets/NotAndALreadySigned.dart';
import '../../widgets/General/MainButton.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    final TextEditingController username = TextEditingController();
    final TextEditingController city = TextEditingController();
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    RxBool isPassVisible = true.obs;

    SignUpController signUpController = Get.put(SignUpController());

    return SingleChildScrollView(
      physics: const PageScrollPhysics(),
      child: Expanded(
        child: Material(
          color: currentTheme.canvasColor,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Logo(currentTheme: currentTheme).marginOnly(top: Get.width*0.077)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Let's Create Your Account",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: currentTheme.primaryColorDark,
                      decoration: TextDecoration.none,
                      fontSize:20,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold),
                ).marginOnly(top: Get.width*0.05, left: Get.width*0.04),
              ),
              Column(
                children: [
                  UsernameField(username: username, currentTheme: currentTheme)
                      ,
                  8.heightBox,
                  CityField(City: city, currentTheme: currentTheme)
                      ,
                  8.heightBox,
                  EmailField(Email: email, currentTheme: currentTheme)
                      ,
                  8.heightBox,
                  PasswordField(
                          isPassVisible: isPassVisible,
                          password: password,
                          currentTheme: currentTheme)
                      ,
                ],
              ).pOnly(top: 35, left: 12, right: 12),
              MainButton(
                      currentTheme: currentTheme,
                      onTap: () async {
                        final check = await signUpController.SigunUp(
                            username.text,
                            email.text,
                            city.text,
                            password.text);
                        if (check) {
                          Get.to(() => const VerificationScreen());
                        }
                      },
                      text: "Sign Up")
                  .marginOnly(top: Get.width * 0.06),
              OrSignInDivider(currentTheme: currentTheme).marginOnly(top: Get.width*0.06),
              GoogleAndFb(currentTheme: currentTheme).marginOnly(top: Get.width*0.06),
              NotAndAlreadySigned(
                firstText: "Already registered?",
                seconfText: "Sign-in",
                currentTheme: currentTheme,
                onTap: () {
                  Get.offAll(() => LogInScreen());
                },
              ).marginOnly(top: Get.width*0.08, bottom: Get.width*0.1)
            ],
          ).pOnly(top: Get.width*0.08, left: Get.width*0.01, right: Get.width*0.01),
        ),
      ),
    );
  }
}
