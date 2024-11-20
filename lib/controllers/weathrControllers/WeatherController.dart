import 'dart:convert';

import 'package:get/get.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:http/http.dart' as http;
import '../../models/weatherModel.dart';
import '../../utils/Themes.dart';
import 'coordinates.dart';

class WeatherController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    clearWeatherData();
  }

  UserController userController = Get.find<UserController>();
  var weatherList = <WeatherModel>[].obs;
    RxList<String> FavCountry = [''].obs;
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
    await Future.wait([
      fetchToday(city),
      fetchForecast(city),
    ]);

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
    try {
      final response = await http.get(
          Uri.parse("http://${AppConstant.domain}/weather/today?city=$city"));

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final weatherdata = WeatherModel.fromJson(responseData);
        addWeatherData(weatherdata);
      } else {
        Get.snackbar('Error in today', responseData['error'],
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (error) {
      print("forecase error : $error");
      Get.snackbar('Error in fetch toda', "$error", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchForecast(String city) async {
    try {
      final response = await http.get(Uri.parse(
          "http://${AppConstant.domain}/weather/forecast?city=$city"));

      if (response.statusCode == 200) {
        final List<dynamic> forecastData = jsonDecode(response.body);

        for (var entry in forecastData) {
          WeatherModel weatherdata = WeatherModel.fromJson(entry);
          addWeatherData(weatherdata);
        }
      } else {
        final responseData = jsonDecode(response.body);
        print('Error in fetch forecasr' + responseData['error']);
        Get.snackbar('Error in fetch forecasr', responseData['error'],
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (error) {
      print("forecase error : $error");
      Get.snackbar('Error in fetch forecast', "$error", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<List<WeatherModel>> getFavWeatherData() async {
    clearFavWeatherData();
    await fetchFavoritesWeather();
    return favoriteWeatherList.toList();
  }
  List<String> getFavCounties() {
    return FavCountry.toList();
  }

  Future<void> fetchFavoritesWeather() async {
    UserController userController = Get.find<UserController>();
    final favLength = userController.user.value!.favorites.length;
    CoordinatesController coordinatesController =
        Get.put(CoordinatesController());
    try {
      List<Future<void>> futures = [];

      FavCountry.clear();

      for (var i = 0; i < favLength; i++) {
        futures.add(fetchFav(userController.user.value!.favorites[i], coordinatesController));
      }

      await Future.wait(futures);
    } catch (error) {
      print("Error fetching all favorites : $error");
    }
  }

  //based on city
  Future<void> fetchFav(String city, CoordinatesController coordinatesController) async {
    try {
      Coord coord = await coordinatesController.fetchcoord(city);
      final responseCountry = await http.get(Uri.parse(
          "http://api.geonames.org/timezoneJSON?lat=${coord.lat}&lng=${coord.lon}&username=wahab_here_"));
      final responseDataCountry = jsonDecode(responseCountry.body);

      final response = await http.get(
          Uri.parse("http://${AppConstant.domain}/weather/today?city=$city"));

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final weatherdata = WeatherModel.fromJson(responseData);
        addFavWeatherData(weatherdata);
        final country = responseDataCountry["countryName"];
        FavCountry.add(country);
      } else {
        Get.snackbar('Error', responseData['error'],
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (error) {
      print("Favorite fetch error : $error");
      Get.snackbar('Error in fetch fav', "$error", snackPosition: SnackPosition.BOTTOM);
    }
  }


}
