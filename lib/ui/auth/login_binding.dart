import 'package:flutter_login_getx/data/repositories/auth_repository.dart';
import 'package:flutter_login_getx/data/repositories/session_repository.dart';
import 'package:get/get.dart';

import '../../data/services/api_client.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient(), permanent: true);

    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find<ApiClient>()));
    Get.lazyPut<SessionRepository>(() => SessionRepository());
    Get.lazyPut<LoginController>(() => LoginController(Get.find<AuthRepository>(), Get.find<SessionRepository>()));
  }
}
