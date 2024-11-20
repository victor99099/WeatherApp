import 'package:get/get.dart';
import 'package:weatherapp/controllers/UserDataaController.dart';

class SortOptionController extends GetxController {
  late UserController userController; // Declare as late
  RxString sortOption = RxString(''); // Initialize with a default value (empty string or any default)

  @override
  void onInit() {
    super.onInit();
    userController = Get.find<UserController>();  // Access userController here
    
    // Initialize sortOption only if it hasn't been set already.
    if (sortOption.value.isEmpty && userController.user.value!.favorites.isNotEmpty) {
      sortOption.value = userController.user.value!.favorites.last;
    }
  }

  void setSortOption(String option) {
    sortOption.value = option;  // This will update the value dynamically
  }

  String getSortOption() {
    return sortOption.value;
  }
}
