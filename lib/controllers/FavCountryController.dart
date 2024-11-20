// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:weatherapp/controllers/UserDataaController.dart';
// import 'package:http/http.dart' as http;
// import 'package:weatherapp/controllers/weathrControllers/coordinates.dart';

// class FavCountryController extends GetxController {
//   RxList<String> FavCountry = [''].obs;

//   List<String> getFavCounties() {
//     return FavCountry.toList();
//   }

//   Future<void> fetchCountries() async {
//     UserController userController = Get.find<UserController>();
//     final user = userController.user.value;
//     CoordinatesController coordinatesController =
//         Get.put(CoordinatesController());
//     try {
//       FavCountry.clear();

//       List<Future<void>> futures = [];

//       for (var favorite in user!.favorites) {
//         futures.add(fetchCountryForFavorites(favorite, coordinatesController));
//       }

//       await Future.wait(futures);
//     } catch (e) {
//       print("error while fetching Country $e");
//       Get.snackbar("Error", "Error recieving data : $e");
//     }
//   }

//   Future<void> fetchCountryForFavorites(
//       String favorite, CoordinatesController coordinatesController) async {
//     try {
//       Coord coord = await coordinatesController.fetchcoord(favorite);
//       final response = await http.get(Uri.parse(
//           "http://api.geonames.org/timezoneJSON?lat=${coord.lat}&lng=${coord.lon}&username=wahab_here_"));
//       final responseData = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         final country = responseData["countryName"];
//         FavCountry.add(country);
//       } else {
//         Get.snackbar(
//             "Error", "Error recieving data : ${responseData['error']}");
//       }
//     } catch (e) {
//       print("Error fetching country for $favorite: $e");
//       Get.snackbar("Error", "Error receiving data: $e");
//     }
//   }
// }
