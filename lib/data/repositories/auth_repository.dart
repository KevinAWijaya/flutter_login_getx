import 'dart:convert';

import 'package:flutter_login_getx/core/base_resource.dart';

import '/../core/globals.dart' as globals;
import '../models/response/response_login.dart';
import '../services/api_client.dart';
import '../services/api_url.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<Resource<ResponseLogin>> login({required String username, required String password}) async {
    try {
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      final response = await apiClient.post(url: ApiUrl.login, headers: {'Authorization': basicAuth, 'Accept': 'application/json'});

      if (response == null) {
        return Error("No response from server");
      }

      if (response.statusCode == 200) {
        final data = response.data;

        final responseLogin = ResponseLogin.fromJson(data);
        globals.accessToken = responseLogin.result!.accesstoken;

        return Success(responseLogin);
      } else {
        return Error(response.data?['message'] ?? "Login failed");
      }
    } catch (e) {
      return Error("Unknown error occurred");
    }
  }
}
