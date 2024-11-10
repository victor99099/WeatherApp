import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/FavCountryController.dart';
import 'package:weatherapp/controllers/weathrControllers/coordinates.dart';
import 'package:weatherapp/controllers/weathrControllers/dateTime.dart';
import 'package:weatherapp/models/weatherModel.dart';
import '../../controllers/UserDataaController.dart';
import '../../widgets/MainScreen Widgets/BottomMain.dart';
import '../../widgets/MainScreen Widgets/LeftMain.dart';
import '../../widgets/MainScreen Widgets/RightMain.dart';

class MainScreen extends StatefulWidget {
  final List<WeatherModel> weatherData;
  final Coord coord;
  final String city;
  final DateTimeController dateTimeController;
  final bool isNight;
  const MainScreen(
      {super.key,
      required this.weatherData,
      required this.coord,
      required this.dateTimeController,
      required this.isNight,
      required this.city});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FavCountryController favCountryController = Get.put(FavCountryController());
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    RxString sortOption = widget.city.obs;

    final currentTheme = Theme.of(context);

    final currentdatetime =
        widget.dateTimeController.getCurrentDateTime(widget.coord);

    WeatherModel todayWeather = widget.weatherData[0];

    List<WeatherModel> forecast = widget.weatherData.sublist(1);

    print(widget.isNight);

    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.transparent,),
      
      backgroundColor: currentTheme.canvasColor,
      body: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                  width: Get.width,
                  height: Get.height * 0.45,
                  child: widget.isNight
                      ? Image.asset(
                          "assets/night.gif",
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          "assets/day.gif",
                          fit: BoxFit.fill,
                        )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeftMain(
                      currentdatetime: currentdatetime,
                      todayWeather: todayWeather,
                      coord: widget.coord),
                  RightMain(
                      isNight: widget.isNight,
                      favCountryController: favCountryController,
                      currentTheme: currentTheme,
                      sortOption: sortOption,
                      widget: widget,
                      todayWeather: todayWeather),
                ],
              )
            ],
          ),
          BottomMain(
              currentTheme: currentTheme,
              widget: widget,
              forecast: forecast,
              sortOption: sortOption,
              todayWeather: todayWeather),
        ],
      ),
    );
  }
}
