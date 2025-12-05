import 'package:flutter/material.dart';
import 'package:vocality_ai/widget/custom/custom_text_field.dart';
import 'package:vocality_ai/widget/custom/sign_in_custom.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Add your password reset logic here
    print('Password reset requested for: $email');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset link sent!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleTryAnotherWay() {
    // Navigate to alternative recovery methods
    print('Try another way tapped');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFFFC107),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 20.0 : 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black87,
                            size: 20,
                          ),
                        ),
                      ),

                      SizedBox(width: 15),

                      // Title
                      Text(
                        'Forgot password',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 26 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),

                  // Description
                  Text(
                    'Don\'t worry it occurs, please enter the email address linked with your account.',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  CustomTextField(
                    controller: _emailController,
                    hintText: 'abcdef@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Try Another Way Button
                  Center(
                    child: TextButton(
                      onPressed: _handleTryAnotherWay,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Try another way',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 20 : 24),

                  // Continue Button
                  SignInCustom(
                    text: 'Continue',
                    isSmallScreen: isSmallScreen,
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text('Password Changed Successfully!'),
                      //     ),
                      //   );
                      // }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
