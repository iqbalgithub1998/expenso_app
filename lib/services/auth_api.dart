import '../core/constants/api_constants.dart';
import 'api_client.dart';

class AuthApi {
  final _client = ApiClient();

  Future<dynamic> login(String email, String password) async {
    final response = await _client.post("${ApiConstants.auth}/login", {
      "email": email,
      "password": password,
    });

    return response;
  }

  Future<dynamic> register(String name, String email, String password) async {
    return await _client.post("${ApiConstants.auth}/register", {
      "name": name,
      "email": email,
      "password": password,
    });
  }

  Future<dynamic> verify() async {
    return await _client.get("${ApiConstants.auth}/refresh");
  }
}
