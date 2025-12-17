// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:vocality_ai/core/gen/assets.gen.dart';

// class ResentOtpScreen extends StatefulWidget {
//   const ResentOtpScreen({super.key});

//   @override
//   State<ResentOtpScreen> createState() => _ResentOtpScreenState();
// }

// class _ResentOtpScreenState extends State<ResentOtpScreen> {
//   final List<TextEditingController> _controllers = List.generate(
//     6,
//     (_) => TextEditingController(),
//   );
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _onChanged(String value, int index) {
//     if (value.isNotEmpty && index < 5) {
//       _focusNodes[index + 1].requestFocus();
//     }
//   }

//   void _onBackspace(int index) {
//     if (index > 0) {
//       _controllers[index].clear();
//       _focusNodes[index - 1].requestFocus();
//     }
//   }

//   String _getOTP() {
//     return _controllers.map((c) => c.text).join();
//   }

//   void _sendCode() {
//     String otp = _getOTP();
//     if (otp.length == 6) {
//       // Handle OTP verification
//       debugPrint('OTP Entered: $otp');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Verifying OTP: $otp')));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter complete OTP')),
//       );
//     }
//   }

//   void _resendCode() {
//     // Handle resend OTP logic
//     debugPrint('Resending OTP...');
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('OTP sent again!')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < 360;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFDD835),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: size.width * 0.05,
//             vertical: 20,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.of(context).pop(),
//                     child: Container(
//                       width: 40,
//                       height: 40,

//                       child: Image.asset(
//                         Assets.icons.backIcon.path,
//                         width: 24,
//                         height: 24,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 15),

//                   // Title
//                   Text(
//                     ' OTP Verify',
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 26 : 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // Description
//               Text(
//                 'Please enter the 6-digit code sent to your email address.',
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 14 : 15,
//                   color: Colors.black87,
//                   height: 1.5,
//                 ),
//               ),

//               SizedBox(height: size.height * 0.04),

//               // OTP Input Fields
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(6, (index) {
//                   return Flexible(
//                     child: Container(
//                       margin: EdgeInsets.symmetric(
//                         horizontal: isSmallScreen ? 3 : 5,
//                       ),
//                       child: AspectRatio(
//                         aspectRatio: 1,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: TextField(
//                             controller: _controllers[index],
//                             focusNode: _focusNodes[index],
//                             textAlign: TextAlign.center,
//                             keyboardType: TextInputType.number,
//                             maxLength: 1,
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 20 : 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               counterText: '',
//                             ),
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                             ],
//                             onChanged: (value) => _onChanged(value, index),
//                             onTap: () {
//                               if (_controllers[index].text.isNotEmpty) {
//                                 _controllers[index].selection =
//                                     TextSelection.fromPosition(
//                                       TextPosition(
//                                         offset: _controllers[index].text.length,
//                                       ),
//                                     );
//                               }
//                             },
//                             onSubmitted: (value) {
//                               if (index == 5) {
//                                 _sendCode();
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),

//               SizedBox(height: size.height * 0.03),

//               // Resend Code
//               Center(
//                 child: TextButton(
//                   onPressed: _resendCode,
//                   child: Text(
//                     'Send code again',
//                     style: TextStyle(
//                       color: Colors.black87,
//                       fontSize: isSmallScreen ? 14 : 16,
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: size.height * 0.03),

//               // Send Code Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     context.push("/passwordChangeScreen");
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(28),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     'Send Code',
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 16 : 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/auth/auth_controller/otp_controller.dart';

class ResentOtpScreen extends StatefulWidget {
  final String email;

  const ResentOtpScreen({super.key, required this.email});

  @override
  State<ResentOtpScreen> createState() => _ResentOtpScreenState();
}

class _ResentOtpScreenState extends State<ResentOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  late final OtpController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = Get.put(OtpController());
    _otpController.setEmail(widget.email);
  }

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

  Future<void> _sendCode() async {
    String otp = _getOTP();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
      return;
    }

    // Update the OTP values in the controller
    for (int i = 0; i < _controllers.length; i++) {
      _otpController.controllers[i].text = _controllers[i].text;
    }

    await _otpController.verifyOtp(context);

    if (!mounted) return;

    // Navigation is handled in the controller
  }

  Future<void> _resendCode() async {
    await _otpController.resendOtp();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFFDD835),
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              Padding(
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
                          child: SizedBox(
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
                    Text(
                      'Please enter the 6-digit code sent to ${widget.email}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
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
                                  onChanged: (value) =>
                                      _onChanged(value, index),
                                  onTap: () {
                                    if (_controllers[index].text.isNotEmpty) {
                                      _controllers[index].selection =
                                          TextSelection.fromPosition(
                                            TextPosition(
                                              offset: _controllers[index]
                                                  .text
                                                  .length,
                                            ),
                                          );
                                    }
                                  },
                                  onSubmitted: (value) {
                                    if (index == 5 &&
                                        !_otpController.isLoading.value) {
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
                    Center(
                      child: _otpController.isResending.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black87,
                                ),
                              ),
                            )
                          : TextButton(
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
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _otpController.isLoading.value
                            ? null
                            : _sendCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: _otpController.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
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
            ],
          );
        }),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/auth/auth_controller/reset_password_otp_controller.dart';

class ResentOtpScreen extends StatefulWidget {
  final String email;

  const ResentOtpScreen({super.key, required this.email});

  @override
  State<ResentOtpScreen> createState() => _ResentOtpScreenState();
}

class _ResentOtpScreenState extends State<ResentOtpScreen> {
  late final ResetPasswordOtpController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ResetPasswordOtpController());
    _controller.setEmail(widget.email);
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _controller.focusNodes[index + 1].requestFocus();
    }
  }

  Future<void> _sendCode() async {
    await _controller.verifyOtp(context);
  }

  Future<void> _resendCode() async {
    await _controller.resendOtp(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFFDD835),
      body: SafeArea(
        child: Obx(() {
          return Padding(
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
                      child: SizedBox(
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
                Text(
                  'Please enter the 6-digit code sent to ${widget.email}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: size.height * 0.04),
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
                              controller: _controller.controllers[index],
                              focusNode: _controller.focusNodes[index],
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
                              onSubmitted: (value) {
                                if (index == 5 &&
                                    !_controller.isLoading.value) {
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
                Center(
                  child: _controller.isResending.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black87,
                            ),
                          ),
                        )
                      : TextButton(
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
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _controller.isLoading.value ? null : _sendCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: _controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
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
              ],
            ),
          );
        }),
      ),
    );
  }
}
