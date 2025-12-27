// lib/features/auth/services/forgot_password_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/base/base_url.dart';
import 'package:vocality_ai/screen/auth/auth_model/forgot_password_request_model.dart';

class ForgotPasswordService {
  static const String baseUrl = AppConfig.httpBase;
  // Using send-reset-password-email endpoint for password reset
  // The resend-otp endpoint is for account activation only
  static const String resendOtpEndpoint =
      '/accounts/user/send-reset-password-email/';

  Future<ForgotPasswordResponse> sendOtp(String email) async {
    try {
      final request = ForgotPasswordRequest(email: email);

      print('Send OTP Request URL: $baseUrl$resendOtpEndpoint');
      print('Send OTP Request Body: ${json.encode(request.toJson())}');

      final response = await http.post(
        Uri.parse('$baseUrl$resendOtpEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      print('Send OTP Response Status: ${response.statusCode}');
      print('Send OTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return ForgotPasswordResponse.fromJson(responseData);
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        String errorMessage = 'Invalid email or request';

        // Try to extract error message from various possible structures
        if (errorData['errors'] != null) {
          // Handle {"errors": {"email": ["message"]}} structure
          final errors = errorData['errors'];
          if (errors is Map) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError.first.toString();
            } else if (firstError is String) {
              errorMessage = firstError;
            }
          }
        } else {
          errorMessage =
              errorData['error'] ??
              errorData['message'] ??
              errorData['detail'] ??
              errorData['email']?.toString() ??
              'Invalid email or request';
        }

        return ForgotPasswordResponse(
          success: false,
          message: 'Failed to send OTP',
          error: errorMessage,
        );
      } else if (response.statusCode == 404) {
        return ForgotPasswordResponse(
          success: false,
          message: 'Email not found',
          error: 'The email address is not registered',
        );
      } else {
        return ForgotPasswordResponse(
          success: false,
          message: 'Failed to send OTP',
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Send OTP Error: $e');
      return ForgotPasswordResponse(
        success: false,
        message: 'Connection error',
        error: e.toString(),
      );
    }
  }
}
