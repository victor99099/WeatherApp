import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Themes.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.currentTheme,
    required this.onTap,
    required this.text
  });

  final ThemeData currentTheme;
  final VoidCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width*0.85,
      height: Get.height * 0.065,
      child: TextButton(
          
          onPressed: onTap,
          style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: WidgetStatePropertyAll(AppConstant.primary),
          ),
          child: Text(text,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: currentTheme.primaryColorDark,
                  fontFamily: GoogleFonts.poppins().fontFamily))),
    );
  }
}