import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';
import 'package:weatherapp/screens/mainScreems/FavoritesScreen.dart';
import 'package:weatherapp/screens/mainScreems/SettingScreen.dart';
import 'package:weatherapp/screens/mainScreems/mainScreen.dart';
import 'package:weatherapp/utils/Themes.dart';

class NavigationMenu extends StatefulWidget {
  final String city;
  final int selectedIndex; // Add selectedIndex parameter

  const NavigationMenu(
      {super.key, required this.city, this.selectedIndex = 0}); // Default to 0

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(NavigationController());
    controller.setCity(widget.city); // Set city here
    controller.selectedIndex.value = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final controller = Get.find<NavigationController>();

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          // animationDuration: Duration(seconds: 2),
          backgroundColor: currentTheme.indicatorColor,
          indicatorColor: AppConstant.primary,
          height: Get.height / 12,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          
          onDestinationSelected: (index) {
            if (!controller.isLoading.value) {
              controller.selectedIndex.value = index;
            } else {
              Get.snackbar('Loading', 'Please wait for the page to load.');
            }
          },
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home, color: currentTheme.primaryColorDark,), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.heart), label: 'Favorites'),
            NavigationDestination(
                icon: Icon(Iconsax.setting), label: 'Settings'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  late UserController userController;
  late List<Widget> screens;
  String? city; // Make it nullable
  final RxBool isLoading = false.obs;

  // Add a method to set the city value
  void setCity(String cityName) {
    city = cityName;
    updateScreens(); // Update screens after city is set
  }

  void updateScreens() {
    // Now that city is set, we can safely initialize screens
    screens = [
      MainScreen(city: city!), // Force unwrap city, as it's set here
      FavoritesScreen(), // Pass city to FavoritesScreen
      SettingScreen(), // Pass city to SettingScreen
    ];
  }

  @override
  void onInit() {
    super.onInit();
    userController = Get.find<UserController>();
  }
}
