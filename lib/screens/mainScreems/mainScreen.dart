import 'package:drop_down_list_menu/drop_down_list_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/controllers/FavCountryController.dart';
import 'package:weatherapp/controllers/weathrControllers/WeatherController.dart';
import 'package:weatherapp/controllers/weathrControllers/coordinates.dart';
import 'package:weatherapp/controllers/weathrControllers/dateTime.dart';
import 'package:weatherapp/models/UserModel.dart';
import 'package:weatherapp/models/weatherModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/screens/AuthScreens/SignInScreen.dart';
import 'package:weatherapp/screens/mainScreems/FavoritesScreen.dart';

import '../../controllers/UserDataaController.dart';

class MainScreen extends StatefulWidget {
  List<WeatherModel> weatherData;
  Coord coord;
  String city;
  DateTimeController dateTimeController;
  MainScreen(
      {super.key,
      required this.weatherData,
      required this.coord,
      required this.dateTimeController,
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
    print("Option Value :  ${sortOption.value}");
    final currentTheme = Theme.of(context);

    final currentdatetime = widget.dateTimeController.getCurrentDateTime(widget.coord);

    WeatherModel todayWeather = widget.weatherData[0];

    List<WeatherModel> forecast = widget.weatherData.sublist(1);

    return Scaffold(
      backgroundColor: currentTheme.canvasColor,
      body: Stack(
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                    width: Get.width,
                    height: Get.height * 0.45,
                    child: Image.asset(
                      "assets/Day.png",
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
                      favCountryController: favCountryController,
                        currentTheme: currentTheme,
                        sortOption: sortOption,
                        widget: widget,
                        todayWeather: todayWeather),
                  ],
                )
              ],
            ),
          ),
          Positioned(
              top: Get.height * 0.4,
              child: Container(
                width: Get.width,
                height: Get.height * 0.63,
                decoration: BoxDecoration(
                  color: currentTheme.canvasColor,
                  border: Border.all(color: Colors.transparent, width: 2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(children: [
                    MainScreenHeadingDivider(
                      currentTheme: currentTheme,
                      text: "7 Day Forecast",
                    ),
                    ForecastList(
                      coord: widget.coord,
                      forecast: forecast,
                      currentTheme: currentTheme,
                      sortOption: sortOption,
                    ),
                    MainScreenHeadingDivider(
                        currentTheme: currentTheme, text: "Weather Details"),
                    Container(
                      height: Get.height * 0.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherDetailBox(
                            currentTheme: currentTheme,
                            todayWeather:
                                todayWeather.humidity.toStringAsFixed(0) + "%",
                            name: "Humidity",
                          ),
                          WeatherDetailBox(
                              currentTheme: currentTheme,
                              todayWeather:
                                  todayWeather.windSpeed.toStringAsFixed(0) +
                                      "2Km/h",
                              name: "Wind Speed"),
                          WeatherDetailBox(
                              currentTheme: currentTheme,
                              todayWeather:
                                  todayWeather.pressure.toStringAsFixed(0) +
                                      "2Km/h",
                              name: "Pressure"),
                        ],
                      ),
                    ).pOnly(top: 10)
                  ]),
                ),
              )),
        ],
      ),
    );
  }
}

class RightMain extends StatelessWidget {
  const RightMain({
    super.key,
    required this.currentTheme,
    required this.sortOption,
    required this.widget,
    required this.todayWeather,
    required this.favCountryController
  });

  final ThemeData currentTheme;
  final RxString sortOption;
  final MainScreen widget;
  final WeatherModel todayWeather;
  final FavCountryController favCountryController;

  @override
  Widget build(BuildContext context) {
    WeatherController weatherController = Get.put(WeatherController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropDownMenu(currentTheme: currentTheme, sortOption: sortOption)
                .marginOnly(top: Get.height * 0.1, left: Get.width * 0.09),
            Container(
              width: Get.width * 0.12,
              height: Get.height * 0.055,
              decoration: BoxDecoration(
                  color: currentTheme.cardColor,
                  border: Border.all(
                    width: 2,
                    color: currentTheme.primaryColorLight,
                  ),
                  borderRadius: BorderRadius.circular(13)),
              child: IconButton(
                  onPressed: () async {
                    List<WeatherModel> FavWeatherList =
                        await weatherController.getFavWeatherData();
                    await favCountryController.fetchCountries();
                    List<String> favCountryList = favCountryController.getFavCounties();
                    Get.to(
                        () => FavoritesScreen(favWeatherList: FavWeatherList, favCountryList:favCountryList));
                  },
                  icon: Icon(
                    Iconsax.heart_add,
                    size: 20,
                    color: currentTheme.highlightColor,
                  )),
            ).marginOnly(top: 73, left: Get.width * 0.01)
          ],
        ),
        Container(
          width: Get.width * 0.3,
          height: Get.height * 0.2,
          child: Column(
            children: [
              Sunriseset(
                text: "Sunrise",
                sun: todayWeather.sunrise,
                icon: Icon(CupertinoIcons.sunrise),
              ),
              20.heightBox,
              Sunriseset(
                  text: "Sunset",
                  sun: todayWeather.sunset,
                  icon: Icon(CupertinoIcons.sunset)),
            ],
          ),
        ).marginOnly(left: Get.width * 0.11, top: 40)
      ],
    );
  }
}

Icon getIconWeatherDetail(String name, BuildContext context) {
  const double iconSize = 16.0; // Set icon size to 16
  final currentTheme = Theme.of(context);
  switch (name.toLowerCase()) {
    case "humidity":
      return Icon(
        Icons.water_outlined,
        color: currentTheme.primaryColorLight.withOpacity(0.5),
        size: 70,
      );
    case "wind speed":
      return Icon(
        Icons.air,
        color: currentTheme.primaryColorLight.withOpacity(0.5),
        size: 70,
      );
    case "pressure":
      return Icon(
        Ionicons.md_speedometer_outline,
        color: currentTheme.primaryColorLight.withOpacity(0.5),
        size: 70,
      );

    default:
      return Icon(WeatherIcons.na,
          color: Colors.black, size: iconSize); // icon for undefined weather
  }
}

class WeatherDetailBox extends StatelessWidget {
  const WeatherDetailBox({
    super.key,
    required this.currentTheme,
    required this.todayWeather,
    required this.name,
  });

  final ThemeData currentTheme;
  final String todayWeather;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Center(
        child: Column(
          children: [
            getIconWeatherDetail(name, context),
            Text(
              todayWeather,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: currentTheme.primaryColorDark),
            ),
            Text(
              "Humidity",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: currentTheme.primaryColorLight),
            )
          ],
        ),
      ),
    );
  }
}

class ForecastList extends StatelessWidget {
  const ForecastList(
      {super.key,
      required this.forecast,
      required this.currentTheme,
      required this.sortOption,
      required this.coord});

  final List<WeatherModel> forecast;
  final ThemeData currentTheme;
  final RxString sortOption;
  final Coord coord;

  @override
  Widget build(BuildContext context) {
    DateTimeController dateTimeController =
        Get.put(DateTimeController(sortOption.value));
    return Container(
      // height: Get.height * 0.5,
      child: ListView.builder(
          itemCount: (forecast.length),
          padding: EdgeInsets.only(top: 8, left: 45),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            currentDateTime dateTime =
                dateTimeController.getDateTime(index + 1, coord);
            return Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width * 0.125,
                    child: Text(
                      dateTime.date,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: currentTheme.primaryColorDark),
                    ).pOnly(bottom: 8),
                  ),
                  Container(
                    width: Get.width * 0.41,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: Get.width * 0.05,
                            child: getIcon(forecast[index].description)),
                        15.widthBox,
                        Container(
                          width: Get.width * 0.192,
                          child: Text(
                            forecast[index].description,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: currentTheme.primaryColorDark),
                          ).pOnly(bottom: 8),
                        ),
                      ],
                    ).pOnly(left: 30),
                  ),
                  Text(
                    "${forecast[index].temperature.toStringAsFixed(0)}/${forecast[index].feelsLike.toStringAsFixed(0)}°",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: currentTheme.primaryColorDark),
                  ).pOnly(left: 30)
                ],
              ).pOnly(top: 10),
            );
          }),
    );
  }
}

class MainScreenHeadingDivider extends StatelessWidget {
  const MainScreenHeadingDivider(
      {super.key, required this.currentTheme, required this.text});

  final ThemeData currentTheme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: currentTheme.primaryColor),
        ).pOnly(top: 20),
        Divider(
          indent: 30,
          endIndent: 30,
        ),
      ],
    );
  }
}

Icon getIcon(String desc) {
  const double iconSize = 16.0; // Set icon size to 16

  switch (desc.toLowerCase()) {
    case "clear sky":
    case "sunny":
    case "mostly clear":
      return Icon(WeatherIcons.day_sunny, color: Colors.orange, size: iconSize);

    case "partly cloudy":
    case "scattered clouds":
    case "few clouds":
      return Icon(WeatherIcons.day_cloudy,
          color: Colors.blueGrey, size: iconSize);

    case "overcast clouds":
    case "mostly cloudy":
    case "broken clouds":
      return Icon(WeatherIcons.cloudy, color: Colors.grey, size: iconSize);

    case "light rain":
    case "drizzle":
      return Icon(WeatherIcons.raindrop,
          color: Colors.lightBlueAccent, size: iconSize);

    case "moderate rain":
    case "heavy rain":
    case "showers":
      return Icon(WeatherIcons.rain, color: Colors.blue, size: iconSize);

    case "thunderstorm":
    case "thunderstorm with rain":
    case "thunderstorm with light rain":
      return Icon(WeatherIcons.thunderstorm,
          color: Colors.deepPurple, size: iconSize);

    case "snow":
    case "light snow":
    case "snow showers":
    case "heavy snow":
      return Icon(WeatherIcons.snow, color: Colors.lightBlue, size: iconSize);

    case "mist":
    case "fog":
    case "haze":
      return Icon(WeatherIcons.fog, color: Colors.grey, size: iconSize);

    case "dust":
    case "sandstorm":
      return Icon(WeatherIcons.sandstorm, color: Colors.brown, size: iconSize);

    case "smoke":
      return Icon(WeatherIcons.smoke, color: Colors.grey, size: iconSize);

    default:
      return Icon(WeatherIcons.na,
          color: Colors.black, size: iconSize); // icon for undefined weather
  }
}

class Sunriseset extends StatelessWidget {
  const Sunriseset(
      {super.key, required this.text, required this.sun, required this.icon});

  final Icon icon;
  final String text;
  final String sun;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          CupertinoIcons.sunset,
          color: Colors.white,
          size: 25,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white),
            ).pOnly(left: Get.width * 0.01),
            Text(
              sun,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white),
            ).pOnly(left: Get.width * 0.01),
          ],
        ).pOnly(left: Get.width * 0.01)
      ],
    );
  }
}

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
    required this.currentTheme,
    required this.sortOption,
  });
  final ThemeData currentTheme;
  final RxString sortOption;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    List<String> cities = userController.user.value!.favorites;
    print(cities);
    return Container(
      // color: currentTheme.cardColor,
      width: Get.width * 0.35,
      height: Get.height * 0.06,
      child: Obx(() {
        return DropdownButtonFormField<String>(
          borderRadius: BorderRadius.circular(25),
          padding: EdgeInsets.all(0),

          style: TextStyle(color: currentTheme.primaryColorDark, fontSize: 14),
          dropdownColor: currentTheme.cardColor,
          icon: Icon(
            Iconsax.arrow_down5,
            color: currentTheme.primaryColorDark,
          ),
          isDense: true,
          iconSize: 10,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.only(left: 219,right: 20,bottom: 10),
          decoration: InputDecoration(
            focusColor: currentTheme.cardColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: currentTheme
                    .primaryColorLight, // Custom color for the bottom line when enabled
                width: 2.0, // Thickness of the bottom line
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: currentTheme
                    .primaryColorLight, // Custom color for the bottom line when focused
                width: 2.0, // Thickness of the bottom line
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors
                    .red, // Custom color for the bottom line when there's an error
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            fillColor: currentTheme.cardColor,
          ),
          value: sortOption.value,
          items: cities
              .map((option) => DropdownMenuItem<String>(
                    child: Text(option),
                    value: option,
                  ))
              .toList(),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              print("Value before ${sortOption.value}");
              sortOption.value = newValue;
              // labe : sortOption.value;
              print("Value after ${sortOption.value}");
              CoordinatesController coordinatesController =
                  Get.put(CoordinatesController());
              Coord coord =
                  await coordinatesController.fetchcoord(sortOption.value);
              DateTimeController dateTimeController =
                  await Get.put(DateTimeController(sortOption.value));
              await dateTimeController.getDateTimeOfCity(coord);
              WeatherController weatherController =
                  await Get.put(WeatherController());
              final List<WeatherModel> weatherData =
                  await weatherController.getWeatherData(sortOption.value);
              Get.offAll(() => MainScreen(
                dateTimeController: dateTimeController,
                    weatherData: weatherData,
                    coord: coord,
                    city: sortOption.value,
                  ));
            }
          },
        );
      }),
    );
  }
}

class LeftMain extends StatelessWidget {
  const LeftMain({
    super.key,
    required this.currentdatetime,
    required this.todayWeather,
    required this.coord,
  });

  final currentDateTime currentdatetime;
  final WeatherModel todayWeather;
  final Coord coord;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.41,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            currentdatetime.time,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white),
          ),
          Text(
            currentdatetime.date,
            style: TextStyle(
                fontSize: 12,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white),
          ).pOnly(left: Get.width * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(todayWeather.temperature.toStringAsFixed(0) + "°C",
                      style: TextStyle(
                          fontSize: 33,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.white))
                  .pOnly(top: Get.width * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "H : ${coord.lon.toStringAsFixed(0)}°",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.white),
                  ),
                  Text(
                    "L : ${coord.lat.toStringAsFixed(0)}°",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.white),
                  )
                ],
              ).pOnly(right: 10)
            ],
          ).pOnly(top: Get.width * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                todayWeather.description.capitalized,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: Colors.white),
              ),
              Icon(
                Iconsax.cloud,
                color: Colors.white,
                size: 18,
              ).pOnly(left: Get.width * 0.01)
            ],
          ),
          Text(
            "Feels Like",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white),
          ).pOnly(top: Get.width * 0.03),
          Text(
            todayWeather.feelsLike.toStringAsFixed(0) + " °C",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white),
          )
        ],
      ).marginOnly(top: Get.height * 0.08, left: Get.width * 0.03),
    );
  }
}
