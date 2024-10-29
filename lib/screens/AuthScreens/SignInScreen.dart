import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:weatherapp/controllers/SiginControllers/NormalSignin.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/screens/AuthScreens/SignupScreen.dart';
import 'package:weatherapp/screens/AuthScreens/intro.dart';
import '../../widgets/Auth Widgets/Divider.dart';
import '../../widgets/Auth Widgets/GoogleAndFbButtons.dart';
import '../../widgets/Auth Widgets/Logo.dart';
import '../../widgets/Auth Widgets/NotAndALreadySigned.dart';
import '../../widgets/Auth Widgets/PassField.dart';
import '../../widgets/Auth Widgets/UsernameField.dart';
import '../../widgets/General/MainButton.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});
  LoginController loginController = Get.put(LoginController());
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  RxBool isPassVisible = true.obs;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Container(
      color: currentTheme.canvasColor,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Login Account",
                style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: currentTheme.primaryColorDark,
                    fontSize: Get.width * 0.05,
                    decoration: TextDecoration.none),
              ),
              10.widthBox,
              ProfileIcon(currentTheme: currentTheme),
            ],
          ).pOnly(top: Get.width*0.16, left: Get.width*0.04, bottom: Get.width*0.035),
          Logo(currentTheme: currentTheme),
          Material(
            child: Column(
              children: [
                UsernameField(username: username, currentTheme: currentTheme)
                    ,
                10.heightBox,
                PasswordField(
                        isPassVisible: isPassVisible,
                        password: password,
                        currentTheme: currentTheme)
                    ,
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password ?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: currentTheme.primaryColorDark,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12),
                  ).pOnly(top: Get.width*0.015, right: Get.width*0.04),
                ),
                MainButton(
                        currentTheme: currentTheme,
                        onTap: () {
                          
                          loginController.login(username.text, password.text);
                          
                        },
                        text: "Login")
                    .marginOnly(top: Get.width*0.06),
                OrSignInDivider(currentTheme: currentTheme).marginOnly(top: Get.width*0.06),
                GoogleAndFb(currentTheme: currentTheme).marginOnly(top: Get.width*0.08),
                NotAndAlreadySigned(
                  seconfText: "Create Account",
                  firstText: "Not registered yet? ",
                  currentTheme: currentTheme,
                  onTap: () {
                    Get.to(() => SignUp());
                  },
                ).marginOnly(top: Get.width*0.08)
              ],
            ),
          ).pOnly(top: 35, left: 12, right: 12),
        ],
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    super.key,
    required this.currentTheme,
  });

  final ThemeData currentTheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Iconsax.user,
          color: currentTheme.primaryColorDark.withOpacity(0.5),
          size: 20,
        ),
        Icon(
          Iconsax.user,
          color: currentTheme.primaryColorDark,
          size: 21,
        ),
        Icon(
          Iconsax.user,
          color: currentTheme.primaryColorDark,
          size: 22,
        ),
        Icon(
          Iconsax.user,
          color: currentTheme.primaryColorDark,
          size: 23,
        ),
        Icon(
          Iconsax.user,
          color: currentTheme.primaryColorDark,
          size: 24,
        ),
        Icon(
          Iconsax.user,
          color: currentTheme.primaryColorDark,
          size: 25,
        ),
        Icon(
          Iconsax.user,
          color: currentTheme.primaryColorDark,
          size: 26,
        ),
      ],
    );
  }
}
