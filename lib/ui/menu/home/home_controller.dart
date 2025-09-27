import 'package:flutter/material.dart';
import 'package:flutter_login_getx/core/base_controller.dart';
import 'package:flutter_login_getx/core/base_resource.dart';
import 'package:flutter_login_getx/data/models/service.dart';
import 'package:flutter_login_getx/data/repositories/service_repository.dart';
import 'package:flutter_login_getx/data/repositories/ticket_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/ticket.dart';

class HomeController extends BaseController {
  final ServiceRepository serviceRepository;
  final TicketRepository ticketRepository;
  HomeController(this.serviceRepository, this.ticketRepository);

  final services = Rx<Resource<List<Service>>>(const Loading());
  final tickets = Rx<Resource<List<Ticket>>>(const Loading());
  var selectedCategory = 'All'.obs;

  DateTime selectedDate = DateTime.now();
  var selectedDateString = ''.obs;

  var totalGrandTotal = 0.obs;
  List<MapEntry<Service, List<Ticket>>> groupedTickets = List.empty(growable: true);

  @override
  Future<void> onInit() async {
    await onRefresh();
    super.onInit();
  }

  Future<void> onRefresh() async {
    startLoading();
    try {
      await fetchServices();
      await fetchTickets();
      recalculate();
    } catch (e) {
      debugPrint("error onRefresh: $e");
    }
    stopLoading();
  }

  Future<void> fetchServices() async {
    try {
      services.value = const Loading();
      final result = await serviceRepository.fetchServices();
      services.value = result;
    } catch (e) {
      debugPrint("error fetchServices: $e");
      rethrow;
    }
  }

  Future<void> fetchTickets() async {
    try {
      tickets.value = Loading();
      final result = await ticketRepository.fetchTickets(date: DateFormat('yyyy-MM-dd').format(selectedDate));
      tickets.value = result;
    } catch (e) {
      debugPrint("error fetchTickets: $e");
      rethrow;
    }
  }

  void recalculate() {
    final serviceCached = services.value.data ?? [];
    final filteredServices = selectedCategory.value == 'All'
        ? serviceCached.where((s) => s.active == 1).toList()
        : serviceCached.where((s) => s.name?.toLowerCase() == selectedCategory.toLowerCase() && s.active == 1).toList();
    groupedTickets = _groupAndSortTicketsByService(services: filteredServices, tickets: tickets.value.data ?? []);
    totalGrandTotal.value = groupedTickets.fold<int>(
      0,
      (sum, entry) => sum + entry.value.fold<int>(0, (subtotal, ticket) => subtotal + (ticket.grandTotal ?? 0)),
    );
  }

  void onClickCategory(String category) {
    selectedCategory.value = category;
    recalculate();
  }

  Future<void> onClickDate(DateTime date) async {
    selectedDate = date;
    selectedDateString.value = DateFormat('EEE, dd MMM yyyy').format(selectedDate);
    await onRefresh();
  }

  List<MapEntry<Service, List<Ticket>>> _groupAndSortTicketsByService({required List<Service> services, required List<Ticket> tickets}) {
    final Map<int, Service> serviceMap = {
      for (var service in services)
        if (service.id != null) service.id!: service,
    };

    // Step 1: Initialize result with all services (empty ticket list)
    final Map<Service, List<Ticket>> result = {
      for (var service in services)
        if (service.id != null) service: [],
    };

    // Step 2: Group tickets into their corresponding services
    for (var ticket in tickets) {
      final serviceId = ticket.fkService;

      if (serviceId == null || !serviceMap.containsKey(serviceId)) continue;

      final service = serviceMap[serviceId]!;

      result[service]!.add(ticket);
    }

    // Step 3: Sort by service.id
    final sortedEntries = result.entries.toList()..sort((a, b) => (a.key.id ?? 0).compareTo(b.key.id ?? 0));

    return sortedEntries;
  }
}
