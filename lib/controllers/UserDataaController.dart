

import 'package:get/get.dart';
import 'package:weatherapp/models/UserModel.dart';

class UserController extends GetxController {
  var user = Rx<User?>(null);

  void setUser(User newUser){
    user.value = newUser;
  }

  void clearUser(){
    user.value =null;
    update();
  }

}