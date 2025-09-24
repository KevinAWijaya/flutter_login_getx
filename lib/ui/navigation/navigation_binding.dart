import 'package:flutter_login_getx/data/repositories/service_repository.dart';
import 'package:flutter_login_getx/data/repositories/ticket_repository.dart';
import 'package:flutter_login_getx/data/services/api_client.dart';
import 'package:flutter_login_getx/ui/menu/home/home_controller.dart';
import 'package:get/get.dart';

import 'navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceRepository>(() => ServiceRepository(Get.find<ApiClient>()));
    Get.lazyPut<NavigationController>(() => NavigationController());

    Get.lazyPut<TicketRepository>(() => TicketRepository(Get.find<ApiClient>()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find<ServiceRepository>(), Get.find<TicketRepository>()));
  }
}
