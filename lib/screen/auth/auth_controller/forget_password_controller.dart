// lib/features/auth/controllers/forgot_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/screen/auth/auth_service/forget_password_service.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordService _service = ForgotPasswordService();

  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isEmailValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to email changes for validation
    emailController.addListener(_validateEmail);
  }

  @override
  void onClose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }

  void _validateEmail() {
    final email = emailController.text;
    isEmailValid.value =
        email.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    errorMessage.value = '';
  }

  String? validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _safeSnackbar(
    String title,
    String message, {
    BuildContext? context,
    Color? backgroundColor,
    Color? colorText,
  }) {
    // Check if GetX overlay context is available
    if (Get.overlayContext != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: backgroundColor,
        colorText: colorText ?? Colors.white,
        duration: const Duration(seconds: 3),
      );
    } else if (context != null && context.mounted) {
      // Fallback to ScaffoldMessenger if GetX context is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title: $message'),
          backgroundColor: backgroundColor ?? Colors.black87,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> sendOtp(BuildContext context) async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Clear previous error
    errorMessage.value = '';

    // Start loading
    isLoading.value = true;

    try {
      final response = await _service.sendOtp(emailController.text.trim());

      if (response.success) {
        // Show success message
        _safeSnackbar(
          'Success',
          response.message,
          // ignore: use_build_context_synchronously
          context: context,
          backgroundColor: Colors.green,
        );

        // Navigate to OTP screen with email parameter
        // ignore: use_build_context_synchronously
        context.push(
          "/resentOtpScreen",
          extra: {'email': emailController.text.trim()},
        );
      } else {
        // Show error message
        final errorMsg = response.error ?? 'Failed to send OTP';
        errorMessage.value = errorMsg;

        _safeSnackbar(
          'Error',
          errorMsg,
          // ignore: use_build_context_synchronously
          context: context,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';

      _safeSnackbar(
        'Error',
        'An unexpected error occurred',
        // ignore: use_build_context_synchronously
        context: context,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }
}
