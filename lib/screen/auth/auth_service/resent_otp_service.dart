// lib/features/auth/data/services/otp_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/screen/auth/auth_model/resent_otp_modell.dart';

class OtpService {
  // Use consistent base URL across all auth services
  static const String baseUrl = 'http://10.10.7.24:8000';

  Future<OtpVerificationResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final request = OtpVerificationRequest(email: email, otp: otp);

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/reset-password-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return OtpVerificationResponse.fromJson(data);
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'OTP verification failed');
        } catch (e) {
          throw Exception(
            'Server error: ${response.statusCode}. Please try again later.',
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<ResendOtpResponse> resendOtp({required String email}) async {
    try {
      final request = ResendOtpRequest(email: email);

      // Update endpoint according to your API
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/send-reset-password-email/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResendOtpResponse.fromJson(data);
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Failed to resend OTP');
        } catch (e) {
          throw Exception(
            'Server error: ${response.statusCode}. Please try again later.',
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to resend OTP: $e');
    }
  }
}

// lib/features/auth/data/services/otp_service.dart
/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/screen/auth/auth_model/resent_otp_modell.dart';

class OtpService {
  // Update this base URL according to your environment
  static const String baseUrl = 'http://10.10.7.24:8000';

  Future<OtpVerificationResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final request = OtpVerificationRequest(email: email, otp: otp);

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/reset-password-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return OtpVerificationResponse.fromJson(data);
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'OTP verification failed');
        } catch (e) {
          throw Exception(
            'Server error: ${response.statusCode}. Please try again later.',
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<ResendOtpResponse> resendOtp({required String email}) async {
    try {
      final request = ResendOtpRequest(email: email);

      // Update endpoint according to your API
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/send-reset-password-email/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResendOtpResponse.fromJson(data);
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Failed to resend OTP');
        } catch (e) {
          throw Exception(
            'Server error: ${response.statusCode}. Please try again later.',
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to resend OTP: $e');
    }
  }
}
*/
