import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/settings_chnage_password/chage_password_model/chage_password_model.dart';

class AuthRepository {
  final String baseUrl = AppConfig.httpBase;

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

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/user/change-password/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return ChangePasswordResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
