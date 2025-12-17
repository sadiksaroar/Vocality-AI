import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PasswordChangeController extends GetxController {
  // Text Controllers
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  // API Base URL - UPDATE THIS TO YOUR ACTUAL IP
  static const String baseUrl = 'http://10.10.7.24:8000';

  // Reset token (should be passed from previous screen)
  String? resetToken;

  @override
  void onInit() {
    super.onInit();
    // Get reset token from arguments if passed via navigation
    if (Get.arguments != null && Get.arguments is Map) {
      resetToken = Get.arguments['reset_token'];
      print('Reset Token received: $resetToken');
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm the password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Show error dialog instead of snackbar to avoid context issues
  void _showErrorDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  // Show success dialog
  void _showSuccessDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // API call to change password
  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check if reset token exists
    if (resetToken == null || resetToken!.isEmpty) {
      print('Error: Reset token is null or empty');
      _showErrorDialog(
        'Error',
        'Reset token not found. Please try the password reset process again.',
      );
      return;
    }

    try {
      isLoading.value = true;

      var headers = {'Content-Type': 'application/json'};

      final url = '$baseUrl/accounts/user/set-new-password/';
      print('Change Password Request URL: $url');

      var request = http.Request('POST', Uri.parse(url));

      final requestBody = {
        "reset_token": resetToken,
        "new_password": passwordController.text,
        "new_password2": confirmPasswordController.text,
      };

      request.body = json.encode(requestBody);
      print('Change Password Request Body: ${request.body}');

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print('Change Password Response Status: ${response.statusCode}');

      String responseBody = await response.stream.bytesToString();
      print('Change Password Response Body: $responseBody');

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);

        _showSuccessDialog(data['msg'] ?? 'Password changed successfully');
      } else if (response.statusCode == 400) {
        var data = json.decode(responseBody);

        String errorMessage = 'Failed to change password';
        if (data is Map) {
          if (data.containsKey('error')) {
            errorMessage = data['error'];
          } else if (data.containsKey('message')) {
            errorMessage = data['message'];
          } else if (data.containsKey('msg')) {
            errorMessage = data['msg'];
          } else if (data.containsKey('detail')) {
            errorMessage = data['detail'];
          }
        }

        _showErrorDialog('Error', errorMessage);
      } else {
        _showErrorDialog(
          'Error',
          'Something went wrong. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Change Password Error: $e');
      _showErrorDialog(
        'Network Error',
        'Failed to connect to server: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Try another way - navigate back to forgot password
  void tryAnotherWay() {
    Get.back(); // Go back to previous screen
  }
}

/*
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PasswordController extends GetxController {
  var isLoading = false.obs;

  Future<void> setNewPassword({
    required String resetToken,
    required String newPassword,
    required String newPassword2,
  }) async {
    isLoading.value = true;

    try {
      var url = Uri.parse(
        'http://127.0.0.1:8000/accounts/user/set-new-password/',
      );
      var headers = {'Content-Type': 'application/json'};
      var body = json.encode({
        'reset_token': resetToken,
        'new_password': newPassword,
        'new_password2': newPassword2,
      });

      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password changed successfully');
      } else {
        Get.snackbar('Error', response.body);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
*/
