import 'package:flutter/material.dart';
import 'package:flutter_login_getx/core/color.dart';
import 'package:flutter_login_getx/core/constants/constants.dart';
import 'package:flutter_login_getx/core/constants/size.dart';
import 'package:flutter_login_getx/core/constants/space.dart';
import 'package:flutter_login_getx/core/routes/app_navigation.dart';
import 'package:flutter_login_getx/data/models/service.dart';
import 'package:flutter_login_getx/ui/menu/home/home_controller.dart';
import 'package:flutter_login_getx/ui/menu/home/widgets/service_card.dart';
import 'package:flutter_login_getx/ui/widgets/button_icon.dart';
import 'package:flutter_login_getx/ui/widgets/loading_page.dart';
import 'package:flutter_login_getx/ui/widgets/text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  Widget _buildCategoryButton(BuildContext context, String label, IconData icon, bool isSelected) {
    return Column(
      children: [
        VButtonIcon(
          icon: icon,
          isSelected: isSelected,
          onTap: () {
            controller.onClickCategory(label);
          },
        ),
        spaceVerticalSmall,
        VText(label, fontSize: textSizeSmall),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColor.surface,
      body: SafeArea(
        child: Obx(
          () => VLoadingOverlay(
            isLoading: controller.isLoadingObs.value,
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(child: _header(context: context)),

                // Category menu
                SliverToBoxAdapter(child: _categoryMenu(context)),

                SliverToBoxAdapter(child: spaceVerticalMedium),

                // Service list yang scrollable
                Obx(() => _servicesList()),

                // filler biar background bawah sama
                SliverFillRemaining(hasScrollBody: false, child: Container(color: VColor.surfaceContainer)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header({required BuildContext context}) {
    final formattedDate = DateFormat('EEE, dd MMM yyyy').format(controller.selectedDate);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Row(
                    children: [
                      VText(formattedDate, fontSize: textSizeLarge),
                      spaceHorizontalSuperSmall,
                      const Icon(Icons.keyboard_arrow_down, color: VColor.onSurface),
                    ],
                  ),
                ),
                spaceVerticalSuperSmall,
                Obx(
                  () => VText(
                    'Sales: ${controller.tickets.value.data?.length ?? 0} · \$${controller.totalGrandTotal.value.toStringAsFixed(2)}',
                    color: VColor.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  VNavigation.toSearchTicketPage(controller.tickets.value.data ?? []);
                },
                icon: const Icon(Icons.search, color: VColor.onSurface, size: iconMedium),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              spaceHorizontalLarge,
              IconButton(
                onPressed: () async {
                  // TODO: log out
                },
                icon: const Icon(Icons.logout, color: VColor.onSurface, size: iconMedium),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: marginLarge),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCategoryButton(context, 'All', Constans.iconList[0], controller.selectedCategory.value == 'All'),
            spaceHorizontalSmall,
            _buildCategoryButton(context, 'Dine In', Constans.iconList[1], controller.selectedCategory.value == 'Dine In'),
            spaceHorizontalSmall,
            _buildCategoryButton(context, 'Take Away', Constans.iconList[2], controller.selectedCategory.value == 'Take Away'),
            spaceHorizontalSmall,
            _buildCategoryButton(context, 'Delivery', Constans.iconList[3], controller.selectedCategory.value == 'Delivery'),
            spaceHorizontalSmall,
            _buildCategoryButton(context, 'General', Constans.iconList[4], controller.selectedCategory.value == 'General'),
          ],
        ),
      ),
    );
  }

  Widget _servicesList() {
    if (controller.selectedCategory.value == "All") {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final entry = controller.groupedTickets[index];
          final service = entry.key;
          final tickets = entry.value;

          return Container(
            decoration: const BoxDecoration(
              color: VColor.surfaceContainer,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: marginMedium),
              child: ServiceCard(service: service, tickets: tickets),
            ),
          );
        }, childCount: controller.groupedTickets.length),
      );
    } else {
      final entry = controller.groupedTickets[0];
      final service = entry.key;
      final tickets = entry.value;

      Service openService = Service(id: service.id, name: "Open");
      final openTickets = tickets.where((element) => element.paid == null).toList();
      Service closeService = Service(id: service.id, name: "Closed");
      final closedTickets = tickets.where((element) => element.paid != null).toList();

      return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            decoration: const BoxDecoration(
              color: VColor.surfaceContainer,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: marginMedium),
              child: Column(
                children: [
                  ServiceCard(service: openService, tickets: openTickets),
                  ServiceCard(service: closeService, tickets: closedTickets),
                ],
              ),
            ),
          ),
        ]),
      );
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: VColor.primary, onPrimary: Colors.white, onSurface: Colors.black),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: VColor.primary)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.onClickDate(picked);
    }
  }
}
