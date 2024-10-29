import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/controllers/UserDataaController.dart';

import '../../models/UserModel.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  
  UserController userController = Get.find<UserController>();

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Username & Password cannt be empty',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;

    try{
      
      final response = await http.post(
        Uri.parse('http://192.168.18.8:3000/auth/signin'),
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
      }
      else{
        
        Get.snackbar('Error', responseData['error'],
          snackPosition: SnackPosition.BOTTOM);
        print("login failed : ${response.statusCode} - ${response.body}");
      }
    }
    catch(error){
      Get.snackbar('Error', "${error}",
          snackPosition: SnackPosition.BOTTOM);
      print('Error during login : $error');
    }
  }
}
