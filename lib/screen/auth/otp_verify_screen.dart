/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  String _getOTP() {
    return _controllers.map((c) => c.text).join();
  }

  void _sendCode() {
    String otp = _getOTP();
    if (otp.length == 6) {
      // Handle OTP verification
      debugPrint('OTP Entered: $otp');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Verifying OTP: $otp')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
    }
  }

  void _resendCode() {
    // Handle resend OTP logic
    debugPrint('Resending OTP...');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP sent again!')));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFFDD835),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,

                      child: Image.asset(
                        Assets.icons.backIcon.path,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Title
                  Text(
                    ' OTP Verify',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 26 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'Please enter the 4-digit code sent to your email address.',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 3 : 5,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) => _onChanged(value, index),
                            onTap: () {
                              if (_controllers[index].text.isNotEmpty) {
                                _controllers[index].selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                        offset: _controllers[index].text.length,
                                      ),
                                    );
                              }
                            },
                            onSubmitted: (value) {
                              if (index == 5) {
                                _sendCode();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: size.height * 0.03),

              // Resend Code
              Center(
                child: TextButton(
                  onPressed: _resendCode,
                  child: Text(
                    'Send code again',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.03),

              // Send Code Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.push("/logInScreen");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Send Code',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

// lib/features/auth/screens/otp_verify_screen.dart
// lib/features/auth/screens/otp_verify_screen.dart
/*


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/auth/auth_controller/otp_controller.dart';

class OtpVerifyScreen extends StatelessWidget {
  const OtpVerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OtpController controller = Get.put(OtpController());
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFFDD835),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        Assets.icons.backIcon.path,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'OTP Verify',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 26 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description with email
              Obx(
                () => Text(
                  controller.email.value.isNotEmpty
                      ? 'Please enter the 6-digit code sent to ${controller.email.value}'
                      : 'Please enter the 6-digit code sent to your email address.',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 3 : 5,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: controller.otpControllers[index],
                            focusNode: controller.focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              controller.onOtpChanged(value, index);
                            },
                            onTap: () {
                              if (controller
                                  .otpControllers[index]
                                  .text
                                  .isNotEmpty) {
                                controller.otpControllers[index].selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                        offset: controller
                                            .otpControllers[index]
                                            .text
                                            .length,
                                      ),
                                    );
                              }
                            },
                            onSubmitted: (value) {
                              if (index == 5) {
                                controller.verifyOtp();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: size.height * 0.03),

              // Error Message Display
              Obx(
                () => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              SizedBox(height: size.height * 0.02),

              // Resend Code Button
              Center(
                child: Obx(
                  () => TextButton(
                    onPressed: controller.isResending.value
                        ? null
                        : controller.resendOtp,
                    child: controller.isResending.value
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Sending...',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          )
                        : Text(
                            'Send code again',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // Verify Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 2,
                      disabledBackgroundColor: Colors.black54,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Verify Code',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
// lib/features/auth/screens/otp_verify_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/auth/auth_controller/otp_controller.dart';

class OtpVerifyScreen extends StatelessWidget {
  final String? email;

  const OtpVerifyScreen({Key? key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController());

    // Set email if passed as parameter
    if (email != null) {
      controller.setEmail(email!);
    }

    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFFDD835),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        Assets.icons.backIcon.path,

                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'OTP Verify',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 26 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => Text(
                  'Please enter the 6-digit code sent to ${controller.email.value.isNotEmpty ? controller.email.value : "your email"}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 3 : 5,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: controller.controllers[index],
                            focusNode: controller.focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) =>
                                controller.onOtpChanged(value, index),
                            onSubmitted: (value) {
                              if (index == 5) {
                                controller.verifyOtp(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: size.height * 0.03),

              // Resend Code Button
              Center(
                child: Obx(
                  () => TextButton(
                    onPressed:
                        controller.isResending.value ||
                            controller.resendTimer.value > 0
                        ? null
                        : controller.resendOtp,
                    child: controller.isResending.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            controller.resendTimer.value > 0
                                ? 'Resend in ${controller.resendTimer.value}s'
                                : 'Send code again',
                            style: TextStyle(
                              color: controller.resendTimer.value > 0
                                  ? Colors.black38
                                  : Colors.black87,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),

              // Send Code Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.verifyOtp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Verify Code',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
