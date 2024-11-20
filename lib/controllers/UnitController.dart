import 'package:get/get.dart';

class UnitController extends GetxController {
  Rx<int> selectedValue = 1.obs; // Holds the selected radio button value

  void onValueChanged(int value) {
    selectedValue.value = value;
    print(selectedValue.value);
  }
}
