import '/../core/globals.dart' as globals;
import '../models/response/data_service.dart';
import '../models/service.dart';
import '../services/api_client.dart';
import '../services/api_url.dart';

class ServiceRepository {
  final ApiClient apiClient;

  ServiceRepository(this.apiClient);

  Future<List<Service>> fetchServices() async {
    final response = await apiClient.get(
      url: ApiUrl.getService,
      headers: {'Authorization': 'Bearer ${globals.accessToken}', 'Content-Type': 'application/json'},
    );

    if (response == null) {
      throw Exception("No response from server");
    }

    if (response.statusCode == 200) {
      final responseLogin = ResponseDataService.fromJson(response.data);

      return responseLogin.result!.service ?? [];
    } else {
      throw Exception('Failed to load services: ${response.statusCode}');
    }
  }
}
