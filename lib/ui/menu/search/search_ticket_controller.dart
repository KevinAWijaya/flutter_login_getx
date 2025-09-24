import 'package:flutter_login_getx/core/base_controller.dart';
import 'package:flutter_login_getx/core/constants/sp.dart';
import 'package:flutter_login_getx/data/models/ticket.dart';
import 'package:get/get.dart';

class SearchTicketController extends BaseController {
  List<Ticket> tickets = List.empty(growable: true);
  var filteredTickets = <Ticket>[].obs;
  @override
  void onInit() {
    startLoading();
    getArgumentData();
    stopLoading();
    super.onInit();
  }

  void getArgumentData() {
    if (argumentData[PrefConst.keyTicketList] != null) {
      tickets = argumentData[PrefConst.keyTicketList];
      filterTicket('');
    }
  }

  void filterTicket(String value) {
    filteredTickets.value = tickets.where((ticket) {
      return (ticket.customerName ?? '').toLowerCase().contains(value) ||
          (ticket.tableDineInName ?? '').toLowerCase().contains(value) ||
          (ticket.barcode ?? '').toLowerCase().contains(value) ||
          (ticket.grandTotal?.toString() ?? '').contains(value);
    }).toList();
  }
}
