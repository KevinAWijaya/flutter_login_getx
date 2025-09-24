import 'package:get/get.dart';

import '../../core/base_controller.dart';

class NavigationController extends BaseController {
  var selectedIndex = 0.obs;

  void onChangePage(int index) {
    selectedIndex.value = index;
  }
}
