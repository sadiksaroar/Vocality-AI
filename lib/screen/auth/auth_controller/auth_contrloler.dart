// lib/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/screen/auth/auth_service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<bool> register({
    required String email,
    required String name,
    required String password,
    required String password2,
    required BuildContext context,
    String? couponCode,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 Starting registration for email: $email');

      final response = await _authService.register(
        email: email,
        name: name,
        password: password,
        password2: password2,
        couponCode: couponCode,
      );

      if (response.success) {
        // Save email to storage for OTP verification
        await StorageHelper.saveEmail(email);

        print('✅ Registration successful!');

        // Use ScaffoldMessenger instead of Get.snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Registration successful!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return true;
      } else {
        errorMessage.value = response.message ?? 'Registration failed';

        print('❌ Registration failed: ${errorMessage.value}');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage.value),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();

      print('❌ Exception during registration: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
