import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';

class ResentOtpScreen extends StatefulWidget {
  const ResentOtpScreen({super.key});

  @override
  State<ResentOtpScreen> createState() => _ResentOtpScreenState();
}

class _ResentOtpScreenState extends State<ResentOtpScreen> {
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

  void _onBackspace(int index) {
    if (index > 0) {
      _controllers[index].clear();
      _focusNodes[index - 1].requestFocus();
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
                    context.push("/passwordChangeScreen");
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
