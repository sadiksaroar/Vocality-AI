import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/widget/color/apps_color.dart';
import 'package:vocality_ai/widget/custom/custom_text_field.dart';
import 'package:vocality_ai/widget/custom/sign_in_custom.dart';
import 'package:vocality_ai/widget/text/text.dart';

// Registration Page
class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.yellowAmber,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 24.0 : 40.0,
              vertical: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  Assets.icons.k.image(width: 108, height: 126),
                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    'Let\'s create new account by registering!',
                    style: MyTextStyles.subHeading,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    hintText: 'abcdef@gmail.com',
                    labelStyle: MyTextStyles.labelText,
                    hintStyle: MyTextStyles.userName,
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

                  const SizedBox(height: 20),

                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Create password',
                    labelStyle: MyTextStyles.labelText,
                    hintStyle: MyTextStyles.userName,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.push("/forgetPasswordScreen");
                          },
                          child: Text(
                            'Forgot Password?',
                            style: MyTextStyles.subHeading,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Confirm Password Field
                  const SizedBox(height: 32),

                  SignInCustom(
                    text: 'Log in',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed to home screen
                        context.push("/homeScreen");
                      }
                    },
                    isSmallScreen: MediaQuery.of(context).size.width < 600,
                  ),
                  const SizedBox(height: 16),

                  // Continue Text
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: const Color(0xFF999999),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'or',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(
                            color: const Color(0xFF3D3D3D),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.70,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  // strokeAlign: BorderSide.strokeAlignCenter,
                                  color: const Color(0xFF999999),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialBtn(
                        icon: Image.asset(
                          Assets.icons.apple.path,
                          height: 24,
                          width: 24,
                        ),
                        text: "Login with Apple",
                      ),

                      // _socialBtn(Asstes.icons.apple.p, text: "Apple"),
                      const SizedBox(height: 10),
                      _socialBtn(
                        icon: Image.asset(
                          Assets.icons.google.path,
                          height: 24,
                          width: 24,
                        ),
                        text: "Login with Google",
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Do you have an account? ',
                        style: MyTextStyles.subHeading,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push("/signInScreen");
                        },
                        child: Text(
                          'Create an Account',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            // height: 1.70,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialBtn({required Widget icon, required String text}) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: icon,
        label: Text(text, style: MyTextStyles.input),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          side: const BorderSide(color: Color(0xFF5C5C5C)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
