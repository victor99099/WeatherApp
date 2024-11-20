import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/controllers/AddFavController.dart';
import 'package:weatherapp/controllers/SelectedCity.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:weatherapp/controllers/weathrControllers/WeatherController.dart';
import 'package:weatherapp/models/weatherModel.dart';
import '../../controllers/GlobalFunctions.dart';
import 'NavigationMenu.dart';

class FavoritesScreen extends StatefulWidget {
  FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final WeatherController weatherController = Get.put(WeatherController());
  // final FavCountryController favCountryController =
  //     Get.put(FavCountryController());
  final AddFavController addFavController = Get.put(AddFavController());
  final UserController userController = Get.find<UserController>();
  final SortOptionController sortOptionController =
      Get.put(SortOptionController());
  NavigationController navigationController = Get.put(NavigationController());

  List<String> favCountryList = [];
  List<WeatherModel> favWeatherList = [];
  var filteredCities = <String>[].obs; // Observable list of filtered cities
  var allCities = <String>[].obs; // Observable list of all cities

  bool isLoading = true;

  TextEditingController newFav = TextEditingController();

  @override
  void initState() {
    super.initState();
    navigationController.isLoading.value = true;
    _fetchData();
    _loadCitiesFromJson();
    filteredCities.value = allCities;
  }

  Future<void> _loadCitiesFromJson() async {
    try {
      // Load JSON data from assets
      final String jsonString =
          await rootBundle.loadString('assets/citiess.json');
      final List<dynamic> cityList = json.decode(jsonString);

      // Update the observable list
      allCities.value = cityList.cast<String>();
    } catch (e) {
      print("Error loading cities: $e");
    }
  }

  Future<void> _fetchData() async {
    try {
      favWeatherList = await weatherController.getFavWeatherData();
      // await weatherController.fetchCountries();
      favCountryList = weatherController.getFavCounties();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      navigationController.isLoading.value = false;
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterCities(String query) {
    filteredCities.value = allCities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    if (isLoading) {
      return Scaffold(
        backgroundColor: currentTheme.canvasColor,
        body: Center(
            child: CircularProgressIndicator(
          color: currentTheme.highlightColor,
        )),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        try {
          EasyLoading.show();
          final user = userController.user.value;
          if (user != null) {
            EasyLoading.dismiss();
            await Get.offAll(
                () => NavigationMenu(
                    city: userController.user.value!.favorites[0]),
                transition: Transition
                    .leftToRightWithFade); // Navigate to the intro screen
            return true;
          }
          return false;
        } catch (error) {
          print("Error Signing In: $error");
          EasyLoading.dismiss();
          return false;
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: currentTheme.canvasColor,
                // barrierColor: currentTheme.cardColor,
                showDragHandle: true,
                isScrollControlled: true,
                useSafeArea: true,
                // isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                      initialChildSize: 0.99,
                      // minChildSize: 0.2,
                      // maxChildSize: 0.9,

                      expand: true,
                      builder: (context, scrollController) {
                        return Container(
                          height: Get.height * 0.8,
                          color: currentTheme.canvasColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  TextFormField(
                                    onChanged: (query) => filterCities(query),
                                    style: TextStyle(
                                        color: currentTheme.primaryColorDark),
                                    controller: newFav,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: currentTheme.cardColor,
                                        hintText: "Enter City",
                                        hintStyle: TextStyle(
                                            color:
                                                currentTheme.primaryColorLight),
                                        prefixIcon: Icon(
                                          Iconsax.map5,
                                          color: currentTheme.primaryColorLight,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color:
                                                    currentTheme.primaryColor,
                                                width: 1.5)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: currentTheme
                                                    .primaryColorLight))),
                                  ).pOnly(left: 15, right: 15),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Suggested Results",
                                      style: TextStyle(
                                          color: currentTheme.primaryColor,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ).pOnly(top: 7, left: 20),
                                  ),
                                  Container(
                                    width: Get.width,
                                    height: Get.height * 0.6,
                                    child: Obx(() {
                                      final isFavCityFound = filteredCities.any(
                                          (city) =>
                                              city.toLowerCase() ==
                                              newFav.text.toLowerCase());

                                      final citiesToDisplay =
                                          filteredCities.take(10).toList();
                                      return ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        itemCount: filteredCities.isEmpty
                                            ? (isFavCityFound ? 0 : 1)
                                            : citiesToDisplay.length,
                                        itemBuilder: (context, index) {
                                          if (filteredCities.isEmpty) {
                                            return Card(
                                              elevation: 0,
                                              color: currentTheme.cardColor,
                                              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: currentTheme.primaryColor)),
                                              child: Text(
                                                "No cities found",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: currentTheme
                                                        .primaryColor),
                                              ).pOnly(left: 1, top: 10),
                                            );
                                          }
                                          if (newFav.text.toLowerCase() ==
                                              filteredCities[index]
                                                  .toLowerCase()) {
                                            return const SizedBox
                                                .shrink(); // Skip the city that matches the selected one
                                          }

                                          return Card(
                                            color: currentTheme.cardColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: currentTheme
                                                        .primaryColor)),
                                            child: ListTile(
                                              title: Text(filteredCities[index],
                                                  style: TextStyle(
                                                      color: currentTheme
                                                          .primaryColor)),
                                              onTap: () {
                                                newFav.text =
                                                    filteredCities[index];
                                                final query = newFav.text;
                                                filterCities(query);
                                                    
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ).pOnly(left: 15, top: 5, right: 15),
                                ],
                              ),
                              TextButton(
                                  style: ButtonStyle(
                                      fixedSize: WidgetStatePropertyAll(Size(
                                          Get.width * 0.8, Get.height * 0.065)),
                                      // padding: WidgetStatePropertyAll(EdgeInsets.all(25)),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      backgroundColor: WidgetStatePropertyAll(
                                          currentTheme.shadowColor)),
                                  onPressed: () async {
                                    EasyLoading.show();
                                    if (await validateCity(newFav.text)) {
                                      await addFavController
                                          .addFavorite(newFav.text);
                                      List<WeatherModel> favWeatherList =
                                          await weatherController
                                              .getFavWeatherData();
                                      favWeatherList = favWeatherList;
                                      // await favCountryController
                                      //     .fetchCountries();

                                      List<String> favCountryList =
                                          weatherController.getFavCounties();
                                      favCountryList = favCountryList;
                                      sortOptionController.setSortOption(
                                          favWeatherList[0].city);
                                      Get.offAll(
                                          () => NavigationMenu(
                                                city: favWeatherList[0].city,
                                                selectedIndex: 1,
                                              ),
                                          transition:
                                              Transition.rightToLeftWithFade);
                                      setState(() {});
                                      EasyLoading.dismiss();
                                      newFav.text = '';
                                    } else {
                                      Get.snackbar("Error",
                                          "City does not exits please check your input");
                                      EasyLoading.dismiss();
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Add to Favorites",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      20.widthBox,
                                      const Icon(
                                        Iconsax.heart_add,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )).pOnly(bottom: 20, left: 20, right: 20)
                            ],
                          ),
                        );
                      });
                });
          },
          backgroundColor: currentTheme.shadowColor,
          child: const Text(
            "+",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ).pOnly(right: 10, bottom: 10),
        backgroundColor: currentTheme.canvasColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: currentTheme.primaryColorDark),
          backgroundColor: Colors.transparent,
          title: Text(
            "Manage Favorites",
            style: TextStyle(
                fontSize: 21,
                color: currentTheme.primaryColorDark,
                fontFamily: GoogleFonts.poppins().fontFamily),
          ),
        ),
        body: ListView.builder(
            itemCount: favWeatherList.length,
            itemBuilder: (BuildContext context, index) {
              return SwipeActionCell(
                backgroundColor: currentTheme.canvasColor,
                trailingActions: [
                  SwipeAction(
                    performsFirstActionWithFullSwipe: true,
                    forceAlignmentToBoundary: false,
                    content: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        height: Get.height / 7.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            // SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                    widthSpace: Get.width / 3,
                    color: Colors.transparent,
                    onTap: (handler) async {
                      if (favWeatherList.length == 1) {
                        Get.snackbar(
                            "Error", "Atleast one favorite should be there");
                      } else {
                        EasyLoading.show();

                        await addFavController.removeFavorite(
                            favWeatherList[index].city.toUpperCase());

                        favWeatherList =
                            await weatherController.getFavWeatherData();
                        // await favCountryController.fetchCountries();
                        favCountryList = weatherController.getFavCounties();
                        favCountryList = favCountryList;
                        setState(() {});
                        EasyLoading.dismiss();
                      }
                    },
                  ),
                ],
                key: ObjectKey(favWeatherList[index].city),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  width: Get.width * 0.8,
                  height: Get.height * 0.15,
                  child: Card(
                    color: currentTheme.shadowColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              favWeatherList[index].city,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.poppins().fontFamily),
                            ),
                            Text(
                                "${favWeatherList[index].temperature.toStringAsFixed(0)}°C",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily))
                          ],
                        ).pOnly(left: 25, right: 25, top: Get.height * 0.017),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              favCountryList[index],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.poppins().fontFamily),
                            ),
                            Text(favWeatherList[index].description.capitalized,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily))
                          ],
                        ).pOnly(left: 25, right: 25, top: 10)
                      ],
                    ),
                  ),
                ),
              );
            }).pOnly(bottom: 60),
      ),
    );
  }
}
