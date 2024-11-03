import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weatherapp/utils/Themes.dart';
import '../../models/UserModel.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final UserController userController = Get.find<UserController>();

  Future<User?> initiateGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('User canceled the sign-in process.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        print('Error: Access Token is null. Cannot proceed without it.');
        return null;
      }

      return await sendTokenToBackend(accessToken);
    } catch (error) {
      print('Error during Google Sign-In: $error');
      return null;
    }
  }

  Future<User?> sendTokenToBackend(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('http://${AppConstant.domain}/auth/google-signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'accessToken': accessToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData is! Map<String, dynamic> ||
            responseData['user'] == null) {
          print('Invalid response format or missing user data.');
          return null;
        }

        final userData = responseData['user'];
        final user = User.fromJson(userData);
        Get.find<UserController>().setUser(user);
        print('Google Sign-In Successful: ${responseData['message']}');
        return user;
      } else {
        print(
            'Google Sign-in Failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error sending token to backend: $error');
      return null;
    }
  }

  final userPool =
      CognitoUserPool('ap-south-1_0LZyWSUxa', '6hffsn13pcleij2248u44ag5tg');

  Future<void> logout() async {
    try{
      await _googleSignIn.signOut();
      print('User signed out from Google.');
      if(userController.user != null){
        final cognitoUser = CognitoUser(userController.user.value!.username, userPool);
        await cognitoUser.signOut();
        print('User signed out from Cognito.');
      }

      final response = await http.get(
        Uri.parse('http://${AppConstant.domain}/auth/logout?username=${userController.user.value!.username}'));

      userController.clearUser();
    }catch(error){
      print('Error during logout: $error');
    }
  }
}
