import 'package:weatherapp/controllers/GlobalFunctions.dart';

class User {
  final String username;
  final String email;
  final List<String> favorites;
  final String unit;
  final int createdAt;
  final bool verificationStatus;

  User({
    required this.username,
    required this.email,
    required this.favorites,
    required this.unit,
    required this.createdAt,
    required this.verificationStatus,
  });

  // Factory constructor to create a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] ?? '', // Default to empty string if null
    email: json['email'] ?? 'No email provided', // Provide a default if null
    favorites: List<String>.from(json['favorites']?.map((city)=>capitalizeFirstLetter(city).trim()) ?? []), // Handle empty or null favorites
    unit: json['unit'] ?? 'Celsius', // Default to 'Celsius' if null
    createdAt: json['createdAt'] ?? 0, // Default to 0 if null (or a reasonable default)
    verificationStatus: json['verificationStatus'] ?? false, // Default to false if null
  );
}

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'favorites': favorites,
      'unit': unit,
      'createdAt': createdAt,
      'verificationStatus': verificationStatus,
    };
  }
}