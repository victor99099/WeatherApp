import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';

import '../../models/UserModel.dart';
import '../../utils/Themes.dart';

class VerifyController extends GetxController {
  Future<bool> verify(String code) async {
    print("Function called");
    UserController userController = Get.find<UserController>();
    User? old_user = userController.user.value;
    if (old_user == null) {
      print("User not found in UserController.");
      Get.snackbar('Error', 'User not found. Please log in again.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    try {
      final body = jsonEncode({
        'username': old_user.username,
        'verificationCode': code,
      });
      final response = await http.post(
          Uri.parse("http://${AppConstant.domain}/auth/verify"),
          headers: {'Content-Type': 'application/json'},
          body: body);

      if (response.statusCode == 200) {
        final reponseData = jsonDecode(response.body);
        User? user = User.fromJson(reponseData);
        userController.setUser(user);
        Get.snackbar('Success', reponseData['message'],
            snackPosition: SnackPosition.BOTTOM);
        return true;
      } else if (response.statusCode == 500) {
        final reponseData = jsonDecode(response.body);
        Get.snackbar('Error', reponseData['error'],
            snackPosition: SnackPosition.BOTTOM);
        return false;
      } else {
        final reponseData = jsonDecode(response.body);
        Get.snackbar('Error', reponseData['error'],
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (error) {
      print("Exception occured : $error");
      Get.snackbar('Error', "${error}", snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<void> resendCode() async {
    UserController userController = Get.find<UserController>();
    User? old_user = userController.user.value;

    if (old_user == null) {
      print("User not found in UserController.");
      Get.snackbar('Error', 'User not found. Please log in again.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      print("pressed");
      final body = jsonEncode({'username' : old_user.username});
      final response = await http.post(
          Uri.parse("http://${AppConstant.domain}/auth/resend-code"),
          headers: {'Content-Type': 'application/json'},
          body: body);
      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200){
        Get.snackbar('Success', responseData['message'],
            snackPosition: SnackPosition.BOTTOM);
      }
      else{
        Get.snackbar('Error', responseData['error'],
            snackPosition: SnackPosition.BOTTOM);
      }
      
    } catch (error) {
      Get.snackbar('Error', "Error while sending code. $error",
            snackPosition: SnackPosition.BOTTOM);
    }
  }
}
