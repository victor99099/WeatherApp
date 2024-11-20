import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:weatherapp/controllers/SelectedCity.dart';
import '../../../controllers/UserDataaController.dart';
import '../../../screens/mainScreems/NavigationMenu.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu(
      {super.key,
      required this.currentTheme,
      required this.sortOption,
      required this.isNight});
  final ThemeData currentTheme;
  final RxString sortOption;
  final bool isNight;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    SortOptionController sortOptionController = Get.put(SortOptionController());

    List<String> cities = userController.user.value!.favorites;

    if (!cities.contains(sortOptionController.sortOption.value)) {
      sortOptionController.setSortOption(cities[0]);
    }
    return SizedBox(
      width: Get.width * 0.35,
      height: Get.height * 0.06,
      child: Obx(() {
        return DropdownButtonFormField<String>(
          borderRadius: BorderRadius.circular(25),
          padding: const EdgeInsets.all(0),

          style: TextStyle(color: currentTheme.primaryColorDark, fontSize: 14),
          dropdownColor: currentTheme.cardColor,
          icon: Icon(
            Iconsax.arrow_down5,
            color: currentTheme.primaryColorDark,
          ),
          isDense: true,
          iconSize: 10,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.only(left: 219,right: 20,bottom: 10),
          decoration: InputDecoration(
            focusColor: currentTheme.cardColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: currentTheme
                    .primaryColorLight, // Custom color for the bottom line when enabled
                width: 2.0, // Thickness of the bottom line
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: currentTheme
                    .primaryColorLight, // Custom color for the bottom line when focused
                width: 2.0, // Thickness of the bottom line
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors
                    .red, // Custom color for the bottom line when there's an error
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            fillColor: currentTheme.cardColor,
          ),
          value: sortOptionController.sortOption.value,
          items: cities
              .map((option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              sortOptionController.setSortOption(newValue);
              EasyLoading.show();
              EasyLoading.dismiss();
              Get.offAll(() =>
                  NavigationMenu(city: sortOptionController.sortOption.value));
            }
          },
        );
      }),
    );
  }
}
