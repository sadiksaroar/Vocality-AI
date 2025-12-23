import 'package:http/http.dart' as http;
import 'package:vocality_ai/screen/auth/auth_model/login_model.dart';
import 'dart:convert';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';

class ApiService {
  static const String baseUrl = 'http://10.10.7.24:8000';
  static const String loginEndpoint = '/accounts/user/login/';

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$loginEndpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonResponse);

        // Save tokens and email to local storage
        await StorageHelper.saveToken(loginResponse.accessToken);
        await StorageHelper.saveRefreshToken(loginResponse.refreshToken);
        await StorageHelper.saveEmail(loginResponse.email);

        return loginResponse;
      } else {
        final errorJson = jsonDecode(response.body);
        throw LoginError.fromJson(errorJson);
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> logout() async {
    try {
      await StorageHelper.clearAll();
      return true;
    } catch (e) {
      return false;
    }
  }
}
