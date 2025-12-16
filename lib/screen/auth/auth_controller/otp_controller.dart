import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/screen/auth/auth_service/otp_service.dart';
import 'package:vocality_ai/screen/auth/model/otp_request_model.dart';
import 'package:vocality_ai/screen/auth/model/resend_otp_request_model.dart';

class OtpController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxString email = ''.obs;
  final RxInt resendTimer = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadEmail();
  }

  void _safeSnackbar(
    String title,
    String message, {
    BuildContext? context,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    Color? backgroundColor,
    Color? colorText,
  }) {
    // Get.snackbar schedules overlay work asynchronously. If Get's
    // overlay context is not available (can happen during app lifecycle
    // transitions or early initialization), the internal queue may throw
    // an unexpected null later. Use ScaffoldMessenger as fallback.
    if (Get.overlayContext == null) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title: $message'),
            backgroundColor: backgroundColor ?? Colors.black87,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        debugPrint('Snackbar skipped (no context): $title - $message');
      }
      return;
    }

    try {
      Get.snackbar(
        title,
        message,
        snackPosition: snackPosition,
        backgroundColor: backgroundColor,
        colorText: colorText,
      );
    } catch (e, st) {
      debugPrint('Snackbar error: $e');
      debugPrint('$st');
    }
  }

  Future<void> _loadEmail() async {
    final savedEmail = await StorageHelper.getEmail();
    if (savedEmail != null) {
      email.value = savedEmail;
    }
  }

  void setEmail(String emailAddress) {
    email.value = emailAddress;
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    final otp = getOtp();

    if (otp.length != 6) {
      _safeSnackbar(
        'Error',
        'Please enter complete 6-digit OTP',
        context: context,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (email.value.isEmpty) {
      _safeSnackbar(
        'Error',
        'Email not found. Please go back and try again.',
        context: context,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = OtpRequestModel(email: email.value, otp: otp);

      final response = await _repository.verifyOtp(request);

      if (response.success) {
        // Save tokens
        if (response.accessToken != null) {
          await StorageHelper.saveToken(response.accessToken!);
        }
        if (response.refreshToken != null) {
          await StorageHelper.saveRefreshToken(response.refreshToken!);
        }

        _safeSnackbar(
          'Success',
          'OTP verified successfully!',
          context: context,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home or login screen
        if (context.mounted) {
          context.go("/logInScreen");
        }
      } else {
        _safeSnackbar(
          'Error',
          response.message,
          context: context,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('OTP Verification Exception: $e');
      _safeSnackbar(
        'Error',
        'Failed to verify OTP. Please check your connection and try again.',
        context: context,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (email.value.isEmpty) {
      _safeSnackbar(
        'Error',
        'Email not found. Please go back and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (resendTimer.value > 0) {
      _safeSnackbar(
        'Wait',
        'Please wait ${resendTimer.value} seconds before resending',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isResending.value = true;

    try {
      final request = ResendOtpRequestModel(email: email.value);
      final success = await _repository.resendOtp(request);

      if (success) {
        _safeSnackbar(
          'Success',
          'OTP sent successfully to ${email.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Start 60 second timer
        startResendTimer();
      } else {
        _safeSnackbar(
          'Error',
          'Failed to resend OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _safeSnackbar(
        'Error',
        'Network error. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isResending.value = false;
    }
  }

  void startResendTimer() {
    resendTimer.value = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (resendTimer.value > 0) {
        resendTimer.value--;
        return true;
      }
      return false;
    });
  }

  @override
  void onClose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
