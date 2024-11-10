
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

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
        const Divider(
          indent: 30,
          endIndent: 30,
        ),
      ],
    );
  }
}