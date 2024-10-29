import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.Email,
    required this.currentTheme,
  });

  final TextEditingController Email;
  final ThemeData currentTheme;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: Email,
      decoration: InputDecoration(
          filled: true,
          fillColor: currentTheme.cardColor,
          hintText: "Enter Email",
          hintStyle: TextStyle(color: currentTheme.primaryColorLight),
          prefixIcon: Icon(
            Iconsax.sms,
            color: currentTheme.primaryColorLight,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: currentTheme.primaryColor, width: 1.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: currentTheme.primaryColorLight))),
    );
  }
}
