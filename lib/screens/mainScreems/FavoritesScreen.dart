import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weatherapp/controllers/AddFavController.dart';
import 'package:weatherapp/controllers/FavCountryController.dart';
import 'package:weatherapp/controllers/SiginControllers/SignupController.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:weatherapp/controllers/weathrControllers/WeatherController.dart';
import 'package:weatherapp/models/weatherModel.dart';
import 'package:weatherapp/screens/mainScreems/mainScreen.dart';
import 'package:weatherapp/utils/Themes.dart';

import '../../controllers/GlobalFunctions.dart';
import '../../controllers/weathrControllers/coordinates.dart';
import '../../controllers/weathrControllers/dateTime.dart';

class FavoritesScreen extends StatefulWidget {
  List<String> favCountryList;
  List<WeatherModel> favWeatherList;
  RxString sortOption;
  bool isNight;
  FavoritesScreen(
      {super.key,required this.sortOption, required this.favWeatherList, required this.favCountryList, required this.isNight});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    
    CoordinatesController coordinatesController =
                Get.put(CoordinatesController());
    
    WeatherController weatherController = Get.put(WeatherController());
    FavCountryController favCountryController = Get.put(FavCountryController());
    AddFavController addFavController = Get.put(AddFavController());
    UserController userController = Get.find<UserController>();

    final currentTheme = Theme.of(context);

    TextEditingController newFav = TextEditingController();

    return WillPopScope(
      onWillPop: () async {
        try {
          EasyLoading.show();
          final user = userController.user.value;
          if (user != null) {
            
            Coord coord =
                await coordinatesController.fetchcoord(widget.sortOption.value);
            DateTimeController dateTimeController =
                Get.put(DateTimeController(widget.sortOption.value));
            await dateTimeController.getDateTimeOfCity(coord);
            
            final List<WeatherModel> weatherData =
                await weatherController.getWeatherData(widget.sortOption.value);
            EasyLoading.dismiss();
            await Get.off(() => MainScreen(
                  isNight: widget.isNight,
                  dateTimeController: dateTimeController,
                  weatherData: weatherData,
                  coord: coord,
                  city: widget.sortOption.value,
                ),transition: Transition.leftToRightWithFade); // Navigate to the intro screen
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
                // isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                      initialChildSize: 1,
                      builder: (context, scrollController) {
                        return Container(
                          // height: Get.height,
                          color: currentTheme.canvasColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFormField(
                                style: TextStyle(
                                    color: currentTheme.primaryColorDark),
                                controller: newFav,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: currentTheme.cardColor,
                                    hintText: "Enter City",
                                    hintStyle: TextStyle(
                                        color: currentTheme.primaryColorLight),
                                    prefixIcon: Icon(
                                      Iconsax.map5,
                                      color: currentTheme.primaryColorLight,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: currentTheme.primaryColor,
                                            width: 1.5)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: currentTheme
                                                .primaryColorLight))),
                              ).pOnly(left: 15, right: 15),
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
                                      widget.favWeatherList = favWeatherList;
                                      await favCountryController
                                          .fetchCountries();

                                      List<String> favCountryList =
                                          favCountryController.getFavCounties();
                                      widget.favCountryList = favCountryList;
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
                                      Text(
                                        "Add to Favorites",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      20.widthBox,
                                      Icon(
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
          child: Text(
            "+",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          backgroundColor: currentTheme.shadowColor,
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
            itemCount: widget.favWeatherList.length,
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
                        margin: EdgeInsets.all(0),
                        height: Get.height / 7.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            // SizedBox(width: 8),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                      ),
                    ),
                    widthSpace: Get.width / 3,
                    color: Colors.transparent,
                    onTap: (handler) async {
                      if (widget.favWeatherList.length == 1)
                        Get.snackbar(
                            "Error", "Atleast one favorite should be there");
                      else {
                        EasyLoading.show();
                        await addFavController.removeFavorite(
                            widget.favWeatherList[index].city.toUpperCase());
                        List<WeatherModel> favWeatherList =
                            await weatherController.getFavWeatherData();
                        widget.favWeatherList = favWeatherList;
                        await favCountryController.fetchCountries();
                        List<String> favCountryList =
                            favCountryController.getFavCounties();
                        widget.favCountryList = favCountryList;
                        setState(() {});
                        EasyLoading.dismiss();
                      }
                    },
                  ),
                ],
                key: ObjectKey(widget.favWeatherList[index].city),
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
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
                              widget.favWeatherList[index].city,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.poppins().fontFamily),
                            ),
                            Text(
                                "${widget.favWeatherList[index].temperature.toStringAsFixed(0)}°C",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily))
                          ],
                        ).pOnly(left: 25, right: 25, top: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.favCountryList[index],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.poppins().fontFamily),
                            ),
                            Text(
                                widget.favWeatherList[index].description
                                    .capitalized,
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
