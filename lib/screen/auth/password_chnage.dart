// import 'package:flutter/material.dart';
// import 'package:vocality_ai/widget/color/apps_color.dart';
// import 'package:vocality_ai/widget/custom/custom_text_field.dart';
// import 'package:vocality_ai/widget/custom/sign_in_custom.dart';

// class PasswordChange extends StatefulWidget {
//   const PasswordChange({Key? key}) : super(key: key);

//   @override
//   State<PasswordChange> createState() => _PasswordChangeState();
// }

// class _PasswordChangeState extends State<PasswordChange> {
//   final _formKey = GlobalKey<FormState>();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < 600;

//     return Scaffold(
//       backgroundColor: AppColors.yellowAmber,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: isSmallScreen ? 24.0 : 40.0,
//               vertical: 20.0,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// ---------------- HEADER ----------------
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 24,
//                   ),
//                   color: const Color(0xFFFFD300),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// Back Button
//                       Container(
//                         height: 32,
//                         width: 32,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(Icons.arrow_back, size: 20),
//                       ),

//                       const SizedBox(width: 12),

//                       /// Title + Subtitle (WRAPPED TO FIX OVERFLOW)
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: const [
//                             Text(
//                               "Change Password",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF0A0A0A),
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               "Replace the password with a new and strong characters.",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF4C4C4C),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 /// ---------------- FORM ----------------
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// PASSWORD
//                       CustomTextField(
//                         controller: _passwordController,
//                         labelText: 'Password',
//                         hintText: 'Enter password',
//                         obscureText: _obscurePassword,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscurePassword
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscurePassword = !_obscurePassword;
//                             });
//                           },
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a password';
//                           }
//                           if (value.length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 20),

//                       /// CONFIRM PASSWORD
//                       CustomTextField(
//                         controller: _confirmPasswordController,
//                         labelText: 'Confirm Password',
//                         hintText: 'Enter confirm password',
//                         obscureText: _obscureConfirmPassword,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscureConfirmPassword
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscureConfirmPassword =
//                                   !_obscureConfirmPassword;
//                             });
//                           },
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please confirm your password';
//                           }
//                           if (value != _passwordController.text) {
//                             return 'Passwords do not match';
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 32),

//                       /// BUTTON
//                       SignInCustom(
//                         text: 'Continue',
//                         isSmallScreen: isSmallScreen,
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Password Changed Successfully!'),
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ChangePasswordHeader extends StatelessWidget {
//   const ChangePasswordHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//       color: const Color(0xFFFFD300), // Yellow background
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Back Button
//           Container(
//             height: 32,
//             width: 32,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.arrow_back, size: 20),
//           ),

//           const SizedBox(width: 12),

//           // Title + Subtitle
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text(
//                 "Change Password",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF0A0A0A),
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 "Replace the password with a new and strong characters.",
//                 style: TextStyle(fontSize: 12, color: Color(0xFF4C4C4C)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/widget/custom/custom_text_field.dart';
import 'package:vocality_ai/widget/custom/sign_in_custom.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({Key? key}) : super(key: key);

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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

              // ---------------------- FORM START ----------------------
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- Back Button ----------
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            // decoration: BoxDecoration(
                            //   color: Colors.white.withOpacity(0.3),
                            //   shape: BoxShape.circle,
                            // ),
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
                          'Change Password',
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
                      'Replace the password with a new and strong character.',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ---------- PASSWORD ----------
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter password',
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
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // ---------- CONFIRM PASSWORD ----------
                    CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter password',
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm the password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          print("Try another way pressed");
                        },
                        child: const Text(
                          'Try another way',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ---------- Continue Button ----------
                    SignInCustom(
                      text: 'Continue',
                      isSmallScreen: isSmallScreen,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password changed successfully'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              // ---------------------- FORM END ----------------------
            ),
          ),
        ),
      ),
    );
  }
}
