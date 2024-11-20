import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/FavCountryController.dart';
import 'package:weatherapp/controllers/weathrControllers/coordinates.dart';
import 'package:weatherapp/controllers/weathrControllers/dateTime.dart';
import 'package:weatherapp/models/weatherModel.dart';
import 'package:weatherapp/screens/mainScreems/NavigationMenu.dart';
import '../../controllers/GlobalFunctions.dart';
import '../../controllers/SelectedCity.dart';
import '../../controllers/UserDataaController.dart';
import '../../controllers/weathrControllers/WeatherController.dart';
import '../../widgets/MainScreen Widgets/BottomMain.dart';
import '../../widgets/MainScreen Widgets/LeftMain.dart';
import '../../widgets/MainScreen Widgets/RightMain.dart';

class MainScreen extends StatefulWidget {
  final String city;

  const MainScreen({required this.city});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoading = true;
  bool isNight = false;
  List<WeatherModel> weatherData = [];
  late Coord coord;
  final WeatherController weatherController = Get.put(WeatherController());
  final SortOptionController sortOptionController =
      Get.put(SortOptionController());
  late DateTimeController dateTimeController;
  // final FavCountryController favCountryController =
  //     Get.put(FavCountryController());
  final UserController userController = Get.find<UserController>();
  NavigationController navigationController = Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
    dateTimeController = Get.put(DateTimeController(widget.city));
    sortOptionController.setSortOption(widget.city);
    navigationController.isLoading.value = true;
    _fetchData();
  }

  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      
      coord = await Get.find<CoordinatesController>().fetchcoord(widget.city);
      await dateTimeController.getDateTimeOfCity(coord);
      weatherData = await weatherController.getWeatherData(widget.city);

      final currentdatetime = dateTimeController.getCurrentDateTime(coord);
      isNight = updateCurrentTime(currentdatetime);
      
    } catch (error) {
      Get.snackbar('Error in fetch data', error.toString(),

          snackPosition: SnackPosition.BOTTOM);
    } finally {
      

      setState(() {
        isLoading = false;
      });
      navigationController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    if (isLoading) {
      return Scaffold(
        backgroundColor :currentTheme.canvasColor,
        body: Center(child: CircularProgressIndicator(color: currentTheme.highlightColor,)),
      );
    }

    
    WeatherModel todayWeather = weatherData[0];
    List<WeatherModel> forecast = weatherData.sublist(1);
    final currentdatetime = dateTimeController.getCurrentDateTime(coord);

    // RxString sortOption = widget.city.obs;

    return Scaffold(
      backgroundColor: currentTheme.canvasColor,
      body: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: Get.width,
                height: kIsWeb ? Get.height * 0.5 : Get.height * 0.45,
                child: isNight
                    ? Image.asset("assets/night.gif", fit: BoxFit.fill)
                    : Image.asset("assets/day.gif", fit: BoxFit.fill),
              ),
              Container(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LeftMain(
                        currentdatetime: currentdatetime,
                        todayWeather: todayWeather,
                        coord: coord),
                    RightMain(
                        isNight: isNight,
                        favCountryController: weatherController,
                        currentTheme: currentTheme,
                        sortOption: sortOptionController.sortOption,
                        todayWeather: todayWeather),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: kIsWeb ? Get.height * 0.45 : Get.height * 0.4,
            child: BottomMain(
              currentTheme: currentTheme,
              coord: coord,
              forecast: forecast,
              sortOption: sortOptionController.sortOption,
              todayWeather: todayWeather,
            ),
          ),
        ],
      ),
    );
  }
}
