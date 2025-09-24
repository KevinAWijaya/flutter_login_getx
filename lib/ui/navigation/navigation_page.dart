import 'package:flutter/material.dart';
import 'package:flutter_login_getx/ui/menu/menu_page.dart';
import 'package:flutter_login_getx/ui/menu/new_order_page.dart';
import 'package:flutter_login_getx/ui/menu/report_page.dart';
import 'package:get/get.dart';

import '../../core/color.dart';
import '../menu/home/home_page.dart';
import 'navigation_controller.dart';

class NavigationPage extends GetView<NavigationController> {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.selectedIndex.value) {
          case 1:
            return NewOrderScreen();
          case 2:
            return ReportScreen();
          case 3:
            return MenuScreen();
          default:
            return HomePage();
        }
      }),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return Obx(
      () => NavigationBar(
        selectedIndex: controller.selectedIndex.value,
        backgroundColor: VColor.surfaceContainerHighest,
        indicatorColor: VColor.secondaryContainer,
        onDestinationSelected: (index) {
          controller.onChangePage(index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: "New Order"),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "Report"),
          NavigationDestination(icon: Icon(Icons.menu), label: "Menu"),
        ],
      ),
    );
  }
}
