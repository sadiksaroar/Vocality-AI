// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vocality_ai/core/gen/assets.gen.dart';
// import 'package:vocality_ai/widget/custom/custom_text_field.dart';
// import 'package:vocality_ai/widget/custom/sign_in_custom.dart';
// import 'package:vocality_ai/widget/text/text.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({Key? key}) : super(key: key);

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final FocusNode _emailFocusNode = FocusNode();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _emailFocusNode.dispose();
//     super.dispose();
//   }

//   void _handleTryAnotherWay() {
//     // Navigate to alternative recovery methods
//     print('Try another way tapped');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < 360;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFFC107),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight:
//                   size.height -
//                   MediaQuery.of(context).padding.top -
//                   MediaQuery.of(context).padding.bottom,
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: isSmallScreen ? 20.0 : 24.0,
//                 vertical: 16.0,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Back Button
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.of(context).pop(),
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.3),
//                             shape: BoxShape.circle,
//                           ),

//                           child: Image.asset(
//                             Assets.icons.backIcon.path,

//                             width: 20,
//                             height: 20,
//                           ),
//                         ),
//                       ),

//                       SizedBox(width: 15),

//                       // Title
//                       Text(
//                         'Forgot password',
//                         style: GoogleFonts.inter(
//                           color: const Color(0xFF2E2E2E),
//                           fontSize: 24,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: isSmallScreen ? 12 : 16),

//                   // Description
//                   Text(
//                     'Don\'t worry it occurs, please enter the email address linked with your account.',
//                     style: MyTextStyles.subHeading,
//                   ),

//                   SizedBox(height: isSmallScreen ? 24 : 32),

//                   CustomTextField(
//                     controller: _emailController,
//                     hintText: 'abcdef@gmail.com',
//                     hintStyle: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 14,
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(
//                         r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                       ).hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),

//                   SizedBox(height: isSmallScreen ? 16 : 20),

//                   SizedBox(height: isSmallScreen ? 20 : 24),

//                   // Continue Button
//                   SignInCustom(
//                     text: 'Continue',
//                     isSmallScreen: isSmallScreen,
//                     onPressed: () {
//                       context.push("/resentOtpScreen");
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/features/auth/screens/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/auth/auth_controller/forget_password_controller.dart';
import 'package:vocality_ai/widget/custom/custom_text_field.dart';
import 'package:vocality_ai/widget/custom/sign_in_custom.dart';
import 'package:vocality_ai/widget/text/text.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
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
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button and Title
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
                            child: Image.asset(
                              Assets.icons.backIcon.path,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Forgot password',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF2E2E2E),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // Description
                    Text(
                      'Don\'t worry it occurs, please enter the email address linked with your account.',
                      style: MyTextStyles.subHeading,
                    ),
                    SizedBox(height: isSmallScreen ? 24 : 32),

                    // Email Field
                    CustomTextField(
                      controller: controller.emailController,
                      focusNode: controller.emailFocusNode,
                      hintText: 'abcdef@gmail.com',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmailField,
                      onChanged: (value) => controller.clearError(),
                    ),

                    // Error Message
                    Obx(() {
                      if (controller.errorMessage.value.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    SizedBox(height: isSmallScreen ? 16 : 20),
                    SizedBox(height: isSmallScreen ? 20 : 24),

                    // Continue Button
                    Obx(
                      () => SignInCustom(
                        text: controller.isLoading.value
                            ? 'Sending...'
                            : 'Continue',
                        isSmallScreen: isSmallScreen,
                        onPressed: controller.isLoading.value
                            ? () {} // Pass an empty function instead of null
                            : () => controller.sendOtp(context),
                      ),
                    ),

                    // Loading Indicator
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
