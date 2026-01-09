import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/screen/auth/auth_model/otp_request_model.dart';
import 'package:vocality_ai/screen/auth/auth_model/resend_otp_request_model.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/settings_chnage_password/chage_password_model/chage_password_model.dart';

class AuthRepository {
  // Use consistent base URL across all auth services
  static const String baseUrl = AppConfig.httpBase;

  Future<OtpResponseModel> verifyOtp(OtpRequestModel request) async {
    try {
      print('OTP Verification Request URL: $baseUrl/accounts/user/verify-otp/');
      print('OTP Verification Request Body: ${json.encode(request.toJson())}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/accounts/user/verify-otp/'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(request.toJson()),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception(
              'Request timeout. Please check your connection.',
            ),
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
          // Check for nested errors structure first
          if (data['errors'] != null &&
              data['errors'] is Map<String, dynamic>) {
            final errors = data['errors'] as Map<String, dynamic>;

            // Check for non_field_errors
            if (errors['non_field_errors'] != null) {
              if (errors['non_field_errors'] is List) {
                errorMessage = (errors['non_field_errors'] as List).join(', ');
              } else {
                errorMessage = errors['non_field_errors'].toString();
              }
            }
            // Check for field-specific errors
            else if (errors['otp'] != null) {
              if (errors['otp'] is List) {
                errorMessage = (errors['otp'] as List).join(', ');
              } else {
                errorMessage = errors['otp'].toString();
              }
            } else if (errors['email'] != null) {
              if (errors['email'] is List) {
                errorMessage = (errors['email'] as List).join(', ');
              } else {
                errorMessage = errors['email'].toString();
              }
            } else {
              // Get first error message from any field
              errorMessage = errors.values.first.toString();
            }
          }
          // Try direct error fields
          else {
            errorMessage =
                data['message'] ??
                data['error'] ??
                data['detail'] ??
                data['otp']?.toString() ??
                data['non_field_errors']?.toString() ??
                'Invalid OTP. Please try again.';
          }
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

  Future<Map<String, dynamic>> resendOtp(ResendOtpRequestModel request) async {
    try {
      print('Resend OTP Request URL: $baseUrl/accounts/user/resend-otp/');
      print('Resend OTP Request Body: ${json.encode(request.toJson())}');

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/resend-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      print('Resend OTP Response Status: ${response.statusCode}');
      print('Resend OTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'OTP sent successfully',
        };
      } else {
        // Parse error response
        final data = json.decode(response.body);
        String errorMessage = 'Failed to resend OTP';

        if (data is Map<String, dynamic>) {
          errorMessage =
              data['message'] ??
              data['error'] ??
              data['detail'] ??
              data['email']?.toString() ??
              'Failed to resend OTP. Please try again.';
        }

        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Resend OTP error: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
      };
    }
  }

  Future<ChangePasswordResponse> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
    required String token,
  }) async {
    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );

      print(
        'Change Password Request URL: $baseUrl/accounts/user/change-password/',
      );
      print('Change Password Request Body: ${json.encode(request.toJson())}');

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/change-password/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      print('Change Password Response Status: ${response.statusCode}');
      print('Change Password Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ChangePasswordResponse(
          success: true,
          message: data['message'] ?? 'Password changed successfully',
        );
      } else {
        final data = json.decode(response.body);
        String errorMessage = 'Failed to change password';

        if (data is Map<String, dynamic>) {
          if (data['errors'] != null &&
              data['errors'] is Map<String, dynamic>) {
            final errors = data['errors'] as Map<String, dynamic>;
            if (errors['non_field_errors'] != null) {
              errorMessage = errors['non_field_errors'] is List
                  ? (errors['non_field_errors'] as List).join(', ')
                  : errors['non_field_errors'].toString();
            } else if (errors['current_password'] != null) {
              errorMessage = errors['current_password'] is List
                  ? (errors['current_password'] as List).join(', ')
                  : errors['current_password'].toString();
            } else if (errors['new_password'] != null) {
              errorMessage = errors['new_password'] is List
                  ? (errors['new_password'] as List).join(', ')
                  : errors['new_password'].toString();
            } else {
              errorMessage = errors.values.first.toString();
            }
          } else {
            errorMessage =
                data['message'] ??
                data['error'] ??
                data['detail'] ??
                'Failed to change password';
          }
        }

        return ChangePasswordResponse(success: false, message: errorMessage);
      }
    } catch (e) {
      print('Change Password Error: $e');
      return ChangePasswordResponse(
        success: false,
        message: 'Network error. Please check your connection and try again.',
      );
    }
  }
}
