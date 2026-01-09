import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/screen/auth/auth_model/login_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Allow overriding via --dart-define=API_BASE_URL and --dart-define=LOGIN_ENDPOINT
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: AppConfig.httpBase,
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

  // Default HTTP client; can be overridden in tests.
  static http.Client httpClient = http.Client();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final Uri uri = Uri.parse(baseUrl).resolve(loginEndpoint);

      final response = await httpClient
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
        String detailedMessage = 'Login failed (HTTP ${response.statusCode}).';
        final responseBody = response.body;

        if (responseBody.isNotEmpty) {
          // Attempt JSON parse first
          try {
            final dynamic parsed = jsonDecode(responseBody);
            if (parsed is Map<String, dynamic>) {
              final loginError = LoginError.fromJson(parsed);

              // Handle authentication errors regardless of status code
              // Some backends incorrectly return 404 for auth failures
              if (loginError.message.isNotEmpty) {
                detailedMessage = loginError.message;
              } else if (response.statusCode == 404) {
                // Special handling for 404 with authentication error
                detailedMessage =
                    'Invalid email or password. Please try again.';
              }
            } else {
              // Non-map JSON (e.g., list), fall back to raw text
              detailedMessage = 'Login failed: $parsed';
            }
          } catch (_) {
            // Not JSON, include raw text body
            if (response.statusCode == 404) {
              detailedMessage =
                  'Invalid email or password. Please check your credentials.';
            } else {
              detailedMessage = 'Login failed: ${responseBody.trim()}';
            }
          }
        } else if (response.statusCode == 404) {
          detailedMessage = 'Login endpoint not found. Please contact support.';
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
