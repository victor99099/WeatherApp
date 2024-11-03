import 'weathrControllers/dateTime.dart';
import 'package:http/http.dart' as http;
String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

bool updateCurrentTime(currentDateTime currentdatetime) {
  String currentTimeString = currentdatetime.time;
  DateTime currentTime = DateTime.parse("1970-01-01 $currentTimeString");

  DateTime nightStartTime = DateTime.parse("1970-01-01 18:00");
  DateTime nightEndTime =
      DateTime.parse("1970-01-01 23:59:59.999"); // End of the same day
  DateTime earlyMorningTime =
      DateTime.parse("1970-01-01 06:00"); // Early morning on the same day


  bool isNight = (currentTime.isAfter(nightStartTime) &&
          currentTime.isBefore(nightEndTime)) ||
      (currentTime.isBefore(earlyMorningTime));

  return isNight;
}
Future<bool> validateCity(String city) async {
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=0571fc40afe0f77bb8737158022c23e5';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // City exists, and weather data is available
        return true;
      } else {
        // City does not exist or invalid city name
        return false;
      }
    } catch (error) {
      print('Error validating city: $error');
      return false;
    }
}