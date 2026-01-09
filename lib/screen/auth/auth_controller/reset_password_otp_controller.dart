import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/screen/auth/auth_service/resent_otp_service.dart';

class ResetPasswordOtpController extends GetxController {
  final OtpService _otpService = OtpService();

  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxString email = ''.obs;
  final RxString errorMessage = ''.obs;

  void setEmail(String emailAddress) {
    email.value = emailAddress;
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  Future<void> verifyOtp(BuildContext context) async {
    final otp = getOtp();

    if (otp.length != 6) {
      _showSnackbar(
        context,
        'Please enter complete 6-digit OTP',
        isError: true,
      );
      return;
    }

    if (email.value.isEmpty) {
      _showSnackbar(context, 'Email not found', isError: true);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _otpService.verifyOtp(
        email: email.value,
        otp: otp,
      );

      isLoading.value = false;

      if (response.success) {
        if (context.mounted) {
          _showSnackbar(context, 'OTP verified successfully!');
          // Navigate to password change screen
          context.push("/passwordChangeScreen");
        }
      } else {
        errorMessage.value = response.message;
        if (context.mounted) {
          _showSnackbar(context, errorMessage.value, isError: true);
        }
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      if (context.mounted) {
        _showSnackbar(
          context,
          errorMessage.value.isNotEmpty
              ? errorMessage.value
              : 'Failed to verify OTP. Please try again.',
          isError: true,
        );
      }
    }
  }

  Future<void> resendOtp(BuildContext context) async {
    if (email.value.isEmpty) {
      _showSnackbar(context, 'Email not found', isError: true);
      return;
    }

    isResending.value = true;

    try {
      final response = await _otpService.resendOtp(email: email.value);

      isResending.value = false;

      if (response.success) {
        if (context.mounted) {
          _showSnackbar(context, 'OTP sent successfully to ${email.value}');
        }
      } else {
        if (context.mounted) {
          _showSnackbar(
            context,
            'Failed to resend OTP. Please try again.',
            isError: true,
          );
        }
      }
    } catch (e) {
      isResending.value = false;
      if (context.mounted) {
        _showSnackbar(
          context,
          'Network error. Please check your connection.',
          isError: true,
        );
      }
    }
  }

  void _showSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
