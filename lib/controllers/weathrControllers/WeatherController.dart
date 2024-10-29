// controllers/weather_controller.dart
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:http/http.dart' as http;
import '../../models/weatherModel.dart';
import '../../utils/Themes.dart';


class WeatherController extends GetxController {

  @override
  void onInit() async {
    super.onInit();
    clearWeatherData();
  }


  UserController userController = Get.find<UserController>();
  var weatherList = <WeatherModel>[].obs;
  var favoriteWeatherList = <WeatherModel>[].obs;
  

  // Method to add weather data
  void addWeatherData(WeatherModel weather) {
    weatherList.add(weather);
  }
  void addFavWeatherData(WeatherModel weather) {
    favoriteWeatherList.add(weather);
  }

  // Method to get weather data
  Future<List<WeatherModel>> getWeatherData(String city) async {
    clearWeatherData();
    await fetchToday(city);
    await fetchForecast(city);
    return weatherList.toList();
  }

  

  // Method to clear weather data
  void clearWeatherData() {
    weatherList.clear();
  }
  void clearFavWeatherData() {
    favoriteWeatherList.clear();
  }



  Future<void> fetchToday(String city) async {
    try{
      final response = await http.get(Uri.parse("http://${AppConstant.domain}/weather/today?city=$city"));

      final responseData = jsonDecode(response.body);
      if(response.statusCode == 200){
        final weatherdata = WeatherModel.fromJson(responseData);
        addWeatherData(weatherdata);

      }
      else{
        Get.snackbar('Error', responseData['error'],
          snackPosition: SnackPosition.BOTTOM);
      }
    } catch(error){
      print("forecase error : $error" );
      Get.snackbar('Error', "${error}",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchForecast(String city) async {
    try{
      final response = await http.get(Uri.parse("http://${AppConstant.domain}/weather/forecast?city=$city"));
      

      if(response.statusCode == 200){
        // final decodedResponse = jsonDecode(response.body);
        // print(decodedResponse);
        final List<dynamic> forecastData = jsonDecode(response.body);
        // print(response.body);

        for(var entry in forecastData){
          WeatherModel weatherdata = WeatherModel.fromJson(entry);
          addWeatherData(weatherdata);
        }
      }
      else{
        final responseData = jsonDecode(response.body);
        Get.snackbar('Error', responseData['error'],
          snackPosition: SnackPosition.BOTTOM);
      }
    } catch(error){
      print("forecase error : $error" );
      Get.snackbar('Error', "$error",
          snackPosition: SnackPosition.BOTTOM);
    }
  }



  Future<List<WeatherModel>> getFavWeatherData() async {
    clearFavWeatherData();
    print("Cleard on fetch"+ "${weatherList.length}");
    await fetchFavoritesWeather();
    print("returning list "+ "${weatherList.length}");
    return favoriteWeatherList.toList();
  }

  Future<void> fetchFavoritesWeather() async {
    UserController userController = Get.find<UserController>();
    final Fav_Length = userController.user.value!.favorites.length;
    print(userController.user.value!.favorites.length);
   try{
    for(var i=0;i<Fav_Length;i++){
      await fetchFav(userController.user.value!.favorites[i]);
    }
   }
   catch(error){
    print("Error fetching all favorites : $error");
   } 
  }
  
  Future<void> fetchFav(String city) async {
    try{
      final response = await http.get(Uri.parse("http://${AppConstant.domain}/weather/today?city=$city"));

      final responseData = jsonDecode(response.body);
      if(response.statusCode == 200){
        final weatherdata = WeatherModel.fromJson(responseData);
        addFavWeatherData(weatherdata);

      }
      else{
        Get.snackbar('Error', responseData['error'],
          snackPosition: SnackPosition.BOTTOM);
      }
    } catch(error){
      print("forecase error : $error" );
      Get.snackbar('Error', "${error}",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  
}
