class WeatherModel {
  final String city;
  final double temperature;
  final double feelsLike;
  final String description;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final String sunrise;
  final String sunset;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'],
      temperature: (json['temperature'] is int)
          ? (json['temperature'] as int).toDouble()
          : json['temperature'],
      feelsLike: (json['feels_like'] is int)
          ? (json['feels_like'] as int).toDouble()
          : json['feels_like'],
      description: json['description'],
      humidity: json['humidity'].toDouble(),
      windSpeed: json['wind_speed'].toDouble(),
      pressure: json['pressure'].toDouble(),
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperature,
      'feels_like': feelsLike,
      'description': description,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'pressure': pressure,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }
}
