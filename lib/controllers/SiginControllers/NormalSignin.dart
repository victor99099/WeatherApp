import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/controllers/UserDataaController.dart';

import '../../models/UserModel.dart';
import '../../utils/Themes.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  
  UserController userController = Get.find<UserController>();

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Username & Password cannt be empty',
          snackPosition: SnackPosition.BOTTOM);
      EasyLoading.dismiss();
      return;
    }
    isLoading.value = true;

    try{
      EasyLoading.show();
      final response = await http.post(
        Uri.parse('http://${AppConstant.domain}/auth/signin'),
        headers: {'Content-Type' : 'application/json'},
        body: json.encode({'username':username,'password':password}),
        
      );
      
      final responseData = jsonDecode(response.body);
      isLoading.value = false;

      if(response.statusCode == 200){
        final userData = responseData['user'];
        User loggedInUser = User.fromJson(userData);
        userController.setUser(loggedInUser);
        print("User logged in");
        EasyLoading.dismiss();
      }
      else{
        
        Get.snackbar('Error', responseData['error'],
          snackPosition: SnackPosition.BOTTOM);
        print("login failed : ${response.statusCode} - ${response.body}");
        EasyLoading.dismiss();
      }
    }
    catch(error){
      Get.snackbar('Error', "${error}",
          snackPosition: SnackPosition.BOTTOM);
      print('Error during login : $error');
      EasyLoading.dismiss();
    }
  }
}
