



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstant{
  static String AppMainName= "Weather Guy";
  static String AppPoweredBy = "Powered by wahab";
  static Color primary = const Color(0xFFD285FF);
  static String domain = "65.2.69.182:3000";
}



class MyTheme {
  

  static ThemeData lightTheme(BuildContext context) => ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    primaryColorLight: const Color.fromARGB(255, 190, 190, 190),
    primaryColorDark: Colors.black,
    primaryColor: const Color.fromARGB(255, 134, 133, 133),
    canvasColor: Colors.white,
    cardColor: Colors.white,
    highlightColor: const Color.fromARGB(255, 98, 46, 128),
    shadowColor: const Color.fromARGB(255, 98, 46, 128)
    
  );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    primaryColor: const Color(0xFFD6D6D6),
    primaryColorDark: Colors.white,
    primaryColorLight: const Color.fromARGB(255, 189, 189, 189),
    canvasColor: const Color(0xFF242424),
    cardColor: const Color.fromARGB(255, 82, 82, 82),
    highlightColor: Colors.white,
    shadowColor: const Color.fromARGB(255, 82, 82, 82)
  );

}