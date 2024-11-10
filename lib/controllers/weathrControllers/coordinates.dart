import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class Coord{
  final double lon;
  final double lat;
  Coord({required this.lat, required this.lon});
}

class CoordinatesController extends GetxController{
  Future<Coord> fetchcoord(String city) async{
    
    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=0571fc40afe0f77bb8737158022c23e5&units=metric"));

    final responseData = jsonDecode(response.body);
    final coord = responseData['coord'];

    return Coord(lat: coord['lat'], lon:coord['lon'] );
    
  }
}
