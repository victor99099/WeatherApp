import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:weatherapp/models/UserModel.dart';

class AddFavController extends GetxController {
  UserController userController = Get.find<UserController>();

  Future<void> addFavorite(String newfav) async {
    try {
      final body = jsonEncode({
        'username': userController.user.value!.username,
        'newfav': newfav,
      });

      final response = await http.post(
          Uri.parse("http://192.168.18.8:3000/fav/addfav"),
          headers: {'Content-Type': 'application/json'},
          body: body);

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200){
        User newuser = User.fromJson(responseData);
        userController.clearUser();
        userController.setUser(newuser);
        print(newuser.email);
      }
      else{
        Get.snackbar("Error", "Error while updating favorites ${responseData['error']}");
      }
    } catch (e) {
      print("Error which updating favorites $e");
    }
  }
}
