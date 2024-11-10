import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

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
        const Icon(
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