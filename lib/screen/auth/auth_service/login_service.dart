import 'package:http/http.dart' as http;
import 'package:vocality_ai/screen/auth/auth_model/login_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Allow overriding via --dart-define=API_BASE_URL and --dart-define=LOGIN_ENDPOINT
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.10.7.24:8000',
  );
  static const String loginEndpoint = String.fromEnvironment(
    'LOGIN_ENDPOINT',
    defaultValue: '/accounts/user/login/',
  );

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final Uri uri = Uri.parse(baseUrl).resolve(loginEndpoint);

      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonResponse);

        // Save tokens and email to local storage
        await StorageHelper.saveToken(loginResponse.accessToken);
        await StorageHelper.saveRefreshToken(loginResponse.refreshToken);
        await StorageHelper.saveEmail(loginResponse.email);

        return loginResponse;
      } else {
        // Debug-only logging for failed responses to diagnose issues like 404
        if (kDebugMode) {
          debugPrint('Login request URL: $uri');
          debugPrint('HTTP ${response.statusCode}');
          debugPrint('Error body: ${response.body}');
        }
        // Try to parse error response for a meaningful message
        final String fallbackMessage =
            'Login failed (HTTP ${response.statusCode}).';

        String detailedMessage = fallbackMessage;
        final responseBody = response.body;

        if (responseBody.isNotEmpty) {
          // Attempt JSON parse first
          try {
            final dynamic parsed = jsonDecode(responseBody);
            if (parsed is Map<String, dynamic>) {
              final loginError = LoginError.fromJson(parsed);
              detailedMessage = loginError.message.isNotEmpty
                  ? '${loginError.message} (HTTP ${response.statusCode})'
                  : fallbackMessage;
            } else {
              // Non-map JSON (e.g., list), fall back to raw text
              detailedMessage = '$fallbackMessage $parsed';
            }
          } catch (_) {
            // Not JSON, include raw text body
            detailedMessage = '$fallbackMessage ${responseBody.trim()}';
          }
        }

        throw Exception(detailedMessage);
      }
    } on SocketException {
      throw Exception('Cannot reach server. Check network or server address.');
    } on http.ClientException {
      throw Exception(
        'Network error: Cannot connect to server. Please check your connection.',
      );
    } on FormatException {
      throw Exception('Invalid server response format.');
    } on Exception {
      rethrow;
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
