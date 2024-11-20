import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/screens/mainScreems/NavigationMenu.dart';
import '../../controllers/SiginControllers/GoogleSignIn.dart';
import '../../controllers/UserDataaController.dart';


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
              EasyLoading.show();
              await authService.initiateGoogleSignIn(context);
              final user = userController.user.value;
              if (user != null) {
                EasyLoading.dismiss();
                Get.off(() => NavigationMenu(
                      city: user.favorites[0],
                    )); // Navigate to the intro screen
              }
              EasyLoading.dismiss();
            } catch (error) {
              print("Error Signing In: $error");
              EasyLoading.dismiss();
            }
          },
          child: SizedBox(
            width: Get.width * 0.25,
            height: Get.height * 0.09,
            child: Card(
                elevation: 2,
                color: currentTheme.cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Image.asset(
                  "assets/google.png",
                )),
          ),
        ),
        20.widthBox,
        SizedBox(
          width: Get.width * 0.25,
          height: Get.height * 0.09,
          child: Card(
              elevation: 2,
              color: currentTheme.cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Image.asset(
                "assets/Fb.png",
              )),
        ),
      ],
    );
  }
}
