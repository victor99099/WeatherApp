import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../models/UserModel.dart';
import '../UserDataaController.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  UserController userController = Get.find<UserController>();

  Future<bool> SigunUp(
      String username, String email, String city, String password) async {
    if (username.isEmpty || password.isEmpty || email.isEmpty || city.isEmpty) {
      Get.snackbar('Error', 'Fields cannot be empty',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    isLoading.value = true;

    bool cityexist = await validateCity(city);

    if (!cityexist) {
      Get.snackbar(
          'Error', 'City does not exist or weather data is not available.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
      return false;
    }

    try {
      final response = await http.post(
          Uri.parse('http://192.168.18.8:3000/auth/signup'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': username,
            'password': password,
            'email': email,
            'favorites': city
          }));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        isLoading.value = false;
        final userData = responseData['user'];
        User loggenInUser = User.fromJson(userData);
        userController.setUser(loggenInUser);
        Get.snackbar('Success', "Please check your email to complete signup",
            snackPosition: SnackPosition.BOTTOM);
        print("Signed Up");
        return true;
      } else {
        Get.snackbar('Error', responseData['error'],
            snackPosition: SnackPosition.BOTTOM);
        print("Sign up failed : ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (error) {
      Get.snackbar('Error', "${error}",
          snackPosition: SnackPosition.BOTTOM);
      print('Error Signup login : $error');
      return false;
    }
  }

  Future<bool> validateCity(String city) async {
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=0571fc40afe0f77bb8737158022c23e5';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // City exists, and weather data is available
        return true;
      } else {
        // City does not exist or invalid city name
        return false;
      }
    } catch (error) {
      print('Error validating city: $error');
      return false;
    }
  }
}
