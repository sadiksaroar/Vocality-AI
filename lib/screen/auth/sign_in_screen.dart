// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vocality_ai/core/gen/assets.gen.dart';
// import 'package:vocality_ai/widget/brand_widget.dart';
// import 'package:vocality_ai/screen/auth/auth_controller/auth_contrloler.dart';
// import 'package:vocality_ai/widget/custom/custom_text_field.dart';
// import 'package:vocality_ai/widget/custom/sign_in_custom.dart';
// import 'package:vocality_ai/widget/text/text.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({Key? key}) : super(key: key);

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _passwordCtrl = TextEditingController();
//   final _confirmCtrl = TextEditingController();

//   final AuthController _authController = Get.put(AuthController());

//   bool _showPass = false;
//   bool _showConfirmPass = false;

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _emailCtrl.dispose();
//     _passwordCtrl.dispose();
//     _confirmCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSignUp() async {
//     if (!_formKey.currentState!.validate()) return;

//     final success = await _authController.register(
//       email: _emailCtrl.text.trim(),
//       name: _nameCtrl.text.trim(),
//       password: _passwordCtrl.text,
//       password2: _confirmCtrl.text,
//       context: context,
//     );

//     if (success && mounted) {
//       context.push("/otpVerifyScreen", extra: _emailCtrl.text.trim());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isSmall = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFFC107),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: isSmall ? 24 : 40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 40),
//               BrandWidget(width: 108, height: 126),
//               const SizedBox(height: 8),
//               Text(
//                 "Sign up to get started with your account",
//                 style: MyTextStyles.subHeading,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),

//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     CustomTextField(
//                       controller: _nameCtrl,
//                       labelText: "Full Name",
//                       labelStyle: MyTextStyles.labelText,
//                       hintText: "Istiak",
//                       hintStyle: MyTextStyles.userName,
//                       validator: (v) =>
//                           v == null || v.isEmpty ? "Enter name" : null,
//                     ),
//                     const SizedBox(height: 16),
//                     CustomTextField(
//                       controller: _emailCtrl,
//                       labelText: "Email",
//                       labelStyle: MyTextStyles.labelText,
//                       hintText: "example@gmail.com",
//                       hintStyle: MyTextStyles.userName,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (v) {
//                         if (v == null || v.isEmpty) return "Enter email";
//                         if (!RegExp(
//                           r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                         ).hasMatch(v))
//                           return "Invalid email";
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     CustomTextField(
//                       controller: _passwordCtrl,
//                       labelText: "Password",
//                       labelStyle: MyTextStyles.labelText,
//                       hintText: "Enter password",
//                       hintStyle: MyTextStyles.userName,
//                       obscureText: !_showPass,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _showPass ? Icons.visibility : Icons.visibility_off,
//                         ),
//                         onPressed: () => setState(() => _showPass = !_showPass),
//                       ),
//                       validator: (v) {
//                         if (v == null || v.isEmpty) return "Enter password";
//                         if (v.length < 6) return "At least 6 chars";
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     CustomTextField(
//                       controller: _confirmCtrl,
//                       labelText: "Confirm Password",
//                       labelStyle: MyTextStyles.labelText,
//                       hintText: "Re-enter password",
//                       hintStyle: MyTextStyles.userName,
//                       obscureText: !_showConfirmPass,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _showConfirmPass
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                         ),
//                         onPressed: () => setState(
//                           () => _showConfirmPass = !_showConfirmPass,
//                         ),
//                       ),
//                       validator: (v) {
//                         if (v == null || v.isEmpty) return "Confirm password";
//                         if (v != _passwordCtrl.text) return "Password mismatch";
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),

//                     Obx(
//                       () => _authController.isLoading.value
//                           ? const CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             )
//                           : SignInCustom(
//                               text: "Sign Up",
//                               isSmallScreen: isSmall,
//                               onPressed: _handleSignUp,
//                             ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),
//               Container(
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   spacing: 10,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: ShapeDecoration(
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                               width: 1,
//                               strokeAlign: BorderSide.strokeAlignCenter,
//                               color: const Color(0xFF999999),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'Continue',
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.notoSans(
//                         color: const Color(0xFF3D3D3D),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         height: 1.70,
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         decoration: ShapeDecoration(
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                               width: 1,
//                               color: const Color(0xFF999999),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),
//               Column(
//                 children: [
//                   _socialBtn(
//                     icon: Image.asset(
//                       Assets.icons.apple.path,
//                       height: 24,
//                       width: 24,
//                     ),
//                     text: "Apple",
//                   ),
//                   const SizedBox(height: 10),
//                   _socialBtn(
//                     icon: Image.asset(
//                       Assets.icons.google.path,
//                       height: 24,
//                       width: 24,
//                     ),
//                     text: "Google",
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Already have account? ",
//                     style: MyTextStyles.subHeading,
//                   ),
//                   GestureDetector(
//                     onTap: () => context.push("/logInScreen"),
//                     child: Text(
//                       "Login",
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         height: 1.70,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _socialBtn({required Widget icon, required String text}) {
//     return Container(
//       height: 50,
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
//       child: OutlinedButton.icon(
//         onPressed: () {},
//         icon: icon,
//         label: Text(text, style: MyTextStyles.input),
//         style: OutlinedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           side: const BorderSide(color: Color(0xFF5C5C5C)),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/widget/brand_widget.dart';
import 'package:vocality_ai/screen/auth/auth_controller/auth_contrloler.dart';
import 'package:vocality_ai/widget/custom/custom_text_field.dart';
import 'package:vocality_ai/widget/custom/sign_in_custom.dart';
import 'package:vocality_ai/widget/text/text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final AuthController _authController = Get.put(AuthController());

  bool _showPass = false;
  bool _showConfirmPass = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.register(
      email: _emailCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      password: _passwordCtrl.text,
      password2: _confirmCtrl.text,
      context: context,
    );

    if (success && mounted) {
      context.push("/otpVerifyScreen", extra: _emailCtrl.text.trim());
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    try {
      final googleSignIn = GoogleSignIn.instance;

      // Initialize Google Sign In (required in v7.x)
      await googleSignIn.initialize();

      // Authenticate the user
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      if (googleUser == null) {
        // User cancelled the sign-in
        setState(() => _isGoogleLoading = false);
        return;
      }

      // Get authorization for scopes
      final auth = await googleUser.authorizationClient.authorizationForScopes([
        'email',
        'profile',
      ]);

      if (auth == null) {
        throw Exception('Failed to get authorization');
      }

      final String? accessToken = auth.accessToken;
      if (accessToken == null) {
        throw Exception('Failed to get access token');
      }

      // Send token to your backend
      final response = await _sendTokenToBackend(accessToken);

      if (response['success'] == true) {
        // Handle successful authentication
        if (mounted) {
          // Save user data or token as needed
          Get.snackbar(
            'Success',
            'Google sign-in successful!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );

          // Navigate to home or dashboard
          context.push("/home"); // Adjust route as needed
        }
      } else {
        throw Exception(response['message'] ?? 'Authentication failed');
      }
    } catch (error) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Google sign-in failed: ${error.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<Map<String, dynamic>> _sendTokenToBackend(String accessToken) async {
    try {
      final url = Uri.parse(
        'http://10.10.7.74:8000/accounts/user/dj-rest-auth/google/',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'access_token': accessToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message':
              'Server returned ${response.statusCode}: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFC107),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isSmall ? 24 : 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              BrandWidget(width: 108, height: 126),
              const SizedBox(height: 8),
              Text(
                "Sign up to get started with your account",
                style: MyTextStyles.subHeading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameCtrl,
                      labelText: "Full Name",
                      labelStyle: MyTextStyles.labelText,
                      hintText: "Istiak",
                      hintStyle: MyTextStyles.userName,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter name" : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailCtrl,
                      labelText: "Email",
                      labelStyle: MyTextStyles.labelText,
                      hintText: "example@gmail.com",
                      hintStyle: MyTextStyles.userName,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Enter email";
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v))
                          return "Invalid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordCtrl,
                      labelText: "Password",
                      labelStyle: MyTextStyles.labelText,
                      hintText: "Enter password",
                      hintStyle: MyTextStyles.userName,
                      obscureText: !_showPass,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPass ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => _showPass = !_showPass),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Enter password";
                        if (v.length < 6) return "At least 6 chars";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmCtrl,
                      labelText: "Confirm Password",
                      labelStyle: MyTextStyles.labelText,
                      hintText: "Re-enter password",
                      hintStyle: MyTextStyles.userName,
                      obscureText: !_showConfirmPass,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPass
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => setState(
                          () => _showConfirmPass = !_showConfirmPass,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Confirm password";
                        if (v != _passwordCtrl.text) return "Password mismatch";
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    Obx(
                      () => _authController.isLoading.value
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : SignInCustom(
                              text: "Sign Up",
                              isSmallScreen: isSmall,
                              onPressed: _handleSignUp,
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Container(
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
                      'Continue',
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
                children: [
                  _socialBtn(
                    icon: Image.asset(
                      Assets.icons.apple.path,
                      height: 24,
                      width: 24,
                    ),
                    text: "Apple",
                    onPressed: () {
                      // Implement Apple sign-in later
                    },
                  ),
                  const SizedBox(height: 10),
                  _isGoogleLoading
                      ? Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFF5C5C5C)),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF5C5C5C),
                              ),
                            ),
                          ),
                        )
                      : _socialBtn(
                          icon: Image.asset(
                            Assets.icons.google.path,
                            height: 24,
                            width: 24,
                          ),
                          text: "Google",
                          onPressed: _handleGoogleSignIn,
                        ),
                ],
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have account? ",
                    style: MyTextStyles.subHeading,
                  ),
                  GestureDetector(
                    onTap: () => context.push("/logInScreen"),
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.70,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialBtn({
    required Widget icon,
    required String text,
    VoidCallback? onPressed,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: OutlinedButton.icon(
        onPressed: onPressed ?? () {},
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
