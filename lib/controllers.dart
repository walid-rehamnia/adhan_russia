import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs; // Observe changes to selectedIndex

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
