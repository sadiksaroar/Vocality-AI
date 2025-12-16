import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vocality_ai/screen/auth/model/otp_request_model.dart';
import 'package:vocality_ai/screen/auth/model/resend_otp_request_model.dart';

class AuthRepository {
  final String baseUrl = 'http://10.10.7.24:8000';

  Future<OtpResponseModel> verifyOtp(OtpRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/verify-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      print('OTP Verification Response Status: ${response.statusCode}');
      print('OTP Verification Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success response
        return OtpResponseModel(
          success: true,
          message: data['message'] ?? 'OTP verified successfully',
          accessToken:
              data['access_token'] ?? data['access'] ?? data['accessToken'],
          refreshToken:
              data['refresh_token'] ?? data['refresh'] ?? data['refreshToken'],
        );
      } else {
        // Error response
        String errorMessage = 'OTP verification failed';

        if (data is Map<String, dynamic>) {
          // Try different possible error message fields
          errorMessage =
              data['message'] ??
              data['error'] ??
              data['detail'] ??
              data['otp']?.toString() ??
              data['non_field_errors']?.toString() ??
              'Invalid OTP. Please try again.';
        }

        return OtpResponseModel(success: false, message: errorMessage);
      }
    } catch (e) {
      print('OTP Verification Error: $e');
      return OtpResponseModel(
        success: false,
        message: 'Network error. Please check your connection and try again.',
      );
    }
  }

  // class OtpResponseModel {
  //
  Future<bool> resendOtp(ResendOtpRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/resend-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Resend OTP error: $e');
      return false;
    }
  }
}
