import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:weatherapp/controllers/weathrControllers/coordinates.dart';
import 'package:weatherapp/models/UserModel.dart';

class currentDateTime {
  final String date;
  final String time;

  currentDateTime({required this.date, required this.time});
}

class DateTimeController extends GetxController {
  Rx<DateTime> DateTimeOfCity = DateTime.now().obs;
  final String city;
  DateTimeController(this.city);

  CoordinatesController coordinatesController = Get.put(CoordinatesController());
  UserController userController = Get.find<UserController>();
  @override
  void onInit() async{
    super.onInit();
    Coord coord = await coordinatesController.fetchcoord(city);
    await getDateTimeOfCity(coord);
  }
  
  
  currentDateTime getDateTime(int day, Coord coord)  {
    final now =  DateTimeOfCity.value;

    final dataFormater =
        "${now.day + day}  ${_getMonthNameForecast(now.month)}";

    final timeFormater =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    print("Date time on getDateTime"+dataFormater + timeFormater);
    return currentDateTime(date: dataFormater, time: timeFormater);
  }

  currentDateTime getCurrentDateTime(Coord coord)  {
    final now =  DateTimeOfCity.value;

    final dataFormater =
        "${_getDayName(now.weekday)}, ${now.day} ${_getMonthName(now.month)}";

    final timeFormater =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
        print("Date time on getcurrentDateTime"+dataFormater + timeFormater);
    return currentDateTime(date: dataFormater, time: timeFormater);
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1]; // Adjust for zero-based index
  }

// Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1]; // Adjust for zero-based index
  }

  String _getMonthNameForecast(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1]; // Adjust for zero-based index
  }

  Future<void> getDateTimeOfCity(Coord coord) async {
    print("lat : ${coord.lat}, long : ${coord.lon}");
    try {
      final response = await http.get(Uri.parse(
          "http://api.geonames.org/timezoneJSON?lat=${coord.lat}&lng=${coord.lon}&username=wahab_here_"));
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 200) {
        String StringTime = responseData['time'];
        DateTime dateTime = DateTime.parse(StringTime);
        print("Date and time : $dateTime");
        DateTimeOfCity.value = dateTime;
      } else {
        Get.snackbar(
            "Error", "Error recieving data : ${responseData['error']}");
        
      }
    } catch (error) {
      print("error while fetching date and time $error");
      Get.snackbar("Error", "Error recieving data : $error");
      
    }
  }
}
