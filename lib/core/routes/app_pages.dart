import 'package:flutter_login_getx/ui/auth/login_binding.dart';
import 'package:flutter_login_getx/ui/auth/login_page.dart';
import 'package:flutter_login_getx/ui/menu/search/search_ticket_binding.dart';
import 'package:flutter_login_getx/ui/menu/search/search_ticket_page.dart';
import 'package:flutter_login_getx/ui/navigation/navigation_binding.dart';
import 'package:flutter_login_getx/ui/navigation/navigation_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const initial = RoutesPath.loginPage;
  static const loginPage = RoutesPath.loginPage;
  static const navigatorPage = RoutesPath.navigationPage;

  static final routes = [
    GetPage(name: RoutesPath.loginPage, page: () => const LoginPage(), binding: LoginBinding(), transition: Transition.noTransition),
    GetPage(name: RoutesPath.navigationPage, page: () => const NavigationPage(), binding: NavigationBinding()),
    GetPage(name: RoutesPath.searchTicketPage, page: () => const SearchTicketPage(), binding: SearchTicketBinding()),
  ];
}
