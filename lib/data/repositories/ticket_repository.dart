import '/../core/globals.dart' as globals;
import '../models/response/data_ticket.dart';
import '../models/service.dart';
import '../models/ticket.dart';
import '../services/api_client.dart';
import '../services/api_url.dart';

class TicketRepository {
  final ApiClient apiClient;

  TicketRepository(this.apiClient);

  Future<List<Ticket>> fetchTickets({String date = "2024-08-05"}) async {
    final response = await apiClient.get(
      url: "${ApiUrl.getTicket}/$date",
      headers: {'Authorization': 'Bearer ${globals.accessToken}', 'Content-Type': 'application/json'},
    );

    if (response == null) {
      throw Exception("No response from server");
    }

    if (response.statusCode == 200) {
      final responseLogin = ResponseDataTicket.fromJson(response.data);

      return responseLogin.result!.ticket ?? [];
    } else {
      throw Exception('Failed to load tickets: ${response.statusCode}');
    }
  }

  Map<Service, List<Ticket>> groupTicketsByService({required List<Service> services, required List<Ticket> tickets}) {
    final Map<int, Service> serviceMap = {
      for (var service in services)
        if (service.id != null) service.id!: service,
    };

    final Map<Service, List<Ticket>> result = {};

    for (var ticket in tickets) {
      final serviceId = ticket.fkService;

      if (serviceId == null || !serviceMap.containsKey(serviceId)) continue;

      final service = serviceMap[serviceId]!;

      result.putIfAbsent(service, () => []).add(ticket);
    }

    return result;
  }
}
