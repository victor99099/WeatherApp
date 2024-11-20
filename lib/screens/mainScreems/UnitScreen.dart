import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/controllers/UnitController.dart';

class UnitScreen extends StatelessWidget {
  UnitScreen({super.key});

  UnitController unitController = Get.put(UnitController());

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: currentTheme.canvasColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: currentTheme.primaryColorDark),
        backgroundColor: Colors.transparent,
        title: Text(
          "Units",
          style: TextStyle(
              fontSize: 21,
              color: currentTheme.primaryColorDark,
              fontFamily: GoogleFonts.poppins().fontFamily),
        ),
      ),
      body: Column(
        children: [
          UnitOption(
            currentTheme: currentTheme,
            unitController: unitController,
            title: "Celcius  °C",
            value: 1,
            upperWidth: 1,
          ),
          UnitOption(
            currentTheme: currentTheme,
            unitController: unitController,
            title: "Fahrenheit  °F",
            value: 2,
            upperWidth: 0,
          ),
        ],
      ),
    );
  }
}

class UnitOption extends StatelessWidget {
  const UnitOption({
    super.key,
    required this.currentTheme,
    required this.unitController,
    required this.title,
    required this.upperWidth,
    required this.value
  });

  final ThemeData currentTheme;
  final UnitController unitController;
  final String title;
  final double upperWidth;
  final int value;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: currentTheme.primaryColorLight, width: upperWidth),
          bottom: BorderSide(color: currentTheme.primaryColorLight, width: 1),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              color: currentTheme.primaryColor,
              fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        trailing: Obx(
          () => Radio<int>(
            value: value,
            groupValue: unitController.selectedValue.value,
            onChanged: (value) {
              if (value != null) {
                unitController.onValueChanged(value);
              }
            },
          ),
        ),
        onTap: () {
            unitController.onValueChanged(value); // Set selected value to 2 when tapped
          },
      ),
    );
  }
}
