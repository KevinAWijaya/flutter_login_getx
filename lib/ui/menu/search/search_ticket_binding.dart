import 'package:flutter_login_getx/ui/menu/search/search_ticket_controller.dart';
import 'package:get/get.dart';

class SearchTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchTicketController>(() => SearchTicketController());
  }
}
