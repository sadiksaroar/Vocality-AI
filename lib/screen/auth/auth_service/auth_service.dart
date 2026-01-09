// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/screen/auth/auth_model/sign_in_screen.dart';

class AuthService {
  static const String baseUrl = AppConfig.httpBase;

  Future<RegisterResponse> register({
    required String email,
    required String name,
    required String password,
    required String password2,
    String? couponCode,
  }) async {
    try {
      // Validate inputs
      if (email.isEmpty || name.isEmpty || password.isEmpty) {
        return RegisterResponse(
          success: false,
          message: 'Please fill all fields',
        );
      }

      if (password != password2) {
        return RegisterResponse(
          success: false,
          message: 'Passwords do not match',
        );
      }

      final request = RegisterRequest(
        email: email,
        name: name,
        password: password,
        password2: password2,
        couponCode: couponCode,
      );

      print('📤 Registration Request: ${request.toJson()}');
      print('🔗 Endpoint: $baseUrl/accounts/user/register/');

      final response = await http
          .post(
            Uri.parse('$baseUrl/accounts/user/register/'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(request.toJson()),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception(
              'Request timeout. Please check your connection.',
            ),
          );

      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final registerResponse = RegisterResponse.fromJson(data);

        // Save token if available
        if (registerResponse.token != null) {
          await StorageHelper.saveToken(registerResponse.token!);
        }

        return registerResponse;
      } else {
        try {
          final error = json.decode(response.body);

          // Handle field-specific errors
          String errorMessage = 'Registration failed';

          if (error is Map) {
            // Check for detail field (Django REST framework standard)
            if (error.containsKey('detail')) {
              errorMessage = error['detail'];
            }
            // Check for message field
            else if (error.containsKey('message')) {
              errorMessage = error['message'];
            }
            // Check for field errors (e.g., {"email": ["This field may not be blank."]})
            else if (error.containsKey('email')) {
              errorMessage = 'Email: ${error['email'].toString()}';
            } else if (error.containsKey('password')) {
              errorMessage = 'Password: ${error['password'].toString()}';
            } else if (error.containsKey('name')) {
              errorMessage = 'Name: ${error['name'].toString()}';
            }
            // Handle generic errors object
            else {
              errorMessage = error.entries.first.value.toString();
            }
          }

          return RegisterResponse(success: false, message: errorMessage);
        } catch (e) {
          return RegisterResponse(
            success: false,
            message: 'Server error (${response.statusCode}): ${response.body}',
          );
        }
      }
    } catch (e) {
      print('❌ Exception: $e');
      return RegisterResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }
}
