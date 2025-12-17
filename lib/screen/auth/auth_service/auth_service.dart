// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/screen/auth/auth_model/sign_in_screen.dart';

class AuthService {
  static const String baseUrl = 'http://10.10.7.24:8000';

  Future<RegisterResponse> register({
    required String email,
    required String name,
    required String password,
    required String password2,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        name: name,
        password: password,
        password2: password2,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final registerResponse = RegisterResponse.fromJson(data);

        // Save token if available
        if (registerResponse.token != null) {
          await StorageHelper.saveToken(registerResponse.token!);
        }

        return registerResponse;
      } else {
        final error = json.decode(response.body);
        return RegisterResponse(
          success: false,
          message: error['message'] ?? error['detail'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      return RegisterResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
