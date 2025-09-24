import 'package:flutter_login_getx/core/constants/sp.dart';
import 'package:flutter_login_getx/data/models/ticket.dart';
import 'package:get/get.dart';

import 'app_pages.dart';

class VNavigation {
  static void offAllUntilSplash() {
    Get.offAllNamed(RoutesPath.splashPage);
  }

  static void toLoginPage() {
    Get.toNamed(RoutesPath.loginPage);
  }

  static void offAllUntilLogin() {
    Get.offAllNamed(RoutesPath.loginPage);
  }

  static void offAllUntilNavigation() {
    Get.offAllNamed(RoutesPath.navigationPage);
  }

  static void toSearchTicketPage(List<Ticket> tickets) {
    Get.toNamed(RoutesPath.searchTicketPage, arguments: {PrefConst.keyTicketList: tickets});
  }
}
