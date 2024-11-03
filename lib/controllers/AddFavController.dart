import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/controllers/GlobalFunctions.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:weatherapp/models/UserModel.dart';

import '../utils/Themes.dart';

class AddFavController extends GetxController {
  UserController userController = Get.find<UserController>();

  Future<void> addFavorite(String newfav) async {
    try {
      final body = jsonEncode({
        'username': userController.user.value!.username,
        'newfav': capitalizeFirstLetter(newfav).trim()
      });

      final response = await http.post(
          Uri.parse("http://${AppConstant.domain}/fav/addfav"),
          headers: {'Content-Type': 'application/json'},
          body: body);

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200){
        User newuser = User.fromJson(responseData);
        userController.clearUser();
        userController.setUser(newuser);
        Get.snackbar("Success", "Favorite added succesfully");
      }
      else{
        Get.snackbar("Error", "Error while updating favorites ${responseData['error']}");
      }
    } catch (e) {
      print("Error which updating favorites $e");
    }
  }

  Future<void> removeFavorite(String fav) async {
    try {
      final favUpperCase = fav.toUpperCase();
      final body = jsonEncode({
        'username': userController.user.value!.username,
        'fav': favUpperCase.trim(),
      });

      final response = await http.post(
          Uri.parse("http://${AppConstant.domain}/fav/removefav"),
          headers: {'Content-Type': 'application/json'},
          body: body);

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200){
        User newuser = User.fromJson(responseData);
        userController.clearUser();
        userController.setUser(newuser);
        Get.snackbar("Success", "Favorite removed succesfully");
      }
      else{
        Get.snackbar("Error", "Error while updating favorites ${responseData['error']} ${response.statusCode}");
      }
    } catch (e) {
      print("Error which updating favorites $e");
    }
  }
}
