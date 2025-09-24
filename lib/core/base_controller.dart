import 'package:get/get.dart';

class BaseController extends GetxController {
  bool isLoading = false;
  var isLoadingObs = false.obs;
  dynamic argumentData = Get.arguments;

  String errorMessage = "";

  startLoading() {
    isLoadingObs.value = true;
  }

  stopLoading() {
    isLoadingObs.value = false;
  }
}
