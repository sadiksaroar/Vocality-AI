import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocality_ai/screen/auth/auth_service/login_service.dart';
import 'package:vocality_ai/screen/auth/auth_model/login_model.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('login success saves tokens and returns LoginResponse', () async {
    final mockResponse = jsonEncode({
      'access': 'access-token-123',
      'refresh': 'refresh-token-456',
      'email': 'user@example.com',
      'message': 'Login successful',
    });

    ApiService.httpClient = MockClient((request) async {
      return http.Response(
        mockResponse,
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final service = ApiService();

    final result = await service.login('user@example.com', 'password');

    expect(result, isA<LoginResponse>());
    expect(result.accessToken, 'access-token-123');
    expect(result.refreshToken, 'refresh-token-456');
    expect(result.email, 'user@example.com');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('access_token'), 'access-token-123');
    expect(prefs.getString('refresh_token'), 'refresh-token-456');
    expect(prefs.getString('user_email'), 'user@example.com');
  });

  test('login failure throws with server error message', () async {
    final errorBody = jsonEncode({'detail': 'Invalid credentials'});

    ApiService.httpClient = MockClient((request) async {
      return http.Response(
        errorBody,
        401,
        headers: {'content-type': 'application/json'},
      );
    });

    final service = ApiService();

    try {
      await service.login('user@example.com', 'wrong');
      fail('Expected exception not thrown');
    } catch (e) {
      final msg = e.toString();
      expect(msg, contains('Invalid credentials'));
    }
  });
}
