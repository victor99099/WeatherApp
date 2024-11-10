import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/models/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/utils/Themes.dart';
class UserController extends GetxController {
  var user = Rx<User?>(null);
  RxBool isLoading = false.obs;



  Future<bool> checkLoginStatus() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    print(username);

    if (username != null) {
      // Call your API to check login status
      final response = await http.get(Uri.parse('http://${AppConstant.domain}/auth/loginstatus?username=$username'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['loggedIn']) {
          print("User logged in :${data['loggedIn']} ");
          user.value = User.fromJson(data['user']);
          isLoading.value = false;
          return true;
        } else {
          print("User Not logged in :${data['loggedIn']} ");
          user.value = null;
          isLoading.value = false;
          return false;
        }
      } else {
        final data = json.decode(response.body);
        print("Failed Response ${data['error']} ");
        user.value = null;
        isLoading.value = false;
        return false;
      }
    } else {
      user.value = null;
      isLoading.value = false;
      return false;
      
    }
    
  }

  void setUser(User newUser) async {
    user.value = newUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUser.username);
  }

  void clearUser() async {
    user.value =null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    update();
  }

}