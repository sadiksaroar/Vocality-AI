// import 'package:flutter/material.dart';
// import 'package:vocality_ai/core/gen/assets.gen.dart';
// import 'package:vocality_ai/widget/color/apps_color.dart';
// import 'package:vocality_ai/widget/custom/custom_text_field.dart';
// import 'package:vocality_ai/widget/custom/sign_in_custom.dart';

// class SettingsChnagePassword extends StatefulWidget {
//   const SettingsChnagePassword({Key? key}) : super(key: key);

//   @override
//   State<SettingsChnagePassword> createState() => _SettingsChnagePasswordState();
// }

// class _SettingsChnagePasswordState extends State<SettingsChnagePassword> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _currentPasswordController =
//       TextEditingController();

//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _currentPasswordController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < 360;

//     return Scaffold(
//       backgroundColor: AppColors.goldenYellow,
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

//               // ---------------------- FORM START ----------------------
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ---------- Back Button ----------
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () => Navigator.of(context).pop(),
//                           child: Container(
//                             width: 40,
//                             height: 40,

//                             child: Image.asset(
//                               Assets.icons.backIcon.path,
//                               width: 24,
//                               height: 24,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 15),

//                         // Title
//                         Expanded(
//                           child: Text(
//                             'Change Password',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 26 : 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 16),

//                     // Description
//                     Text(
//                       'Replace the password with a new and strong character.',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 14 : 15,
//                         color: Colors.black87,
//                         height: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 32),

//                     CustomTextField(
//                       controller: _currentPasswordController,
//                       labelText: 'Current Password',
//                       hintText: 'Enter password',
//                       hintStyle: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                       obscureText: _obscurePassword,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a password';
//                         }
//                         if (value.length < 6) {
//                           return 'Password must be at least 6 characters long';
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 32),

//                     // ---------- PASSWORD ----------
//                     CustomTextField(
//                       controller: _newPasswordController,
//                       labelText: 'New Password',
//                       hintText: 'Enter password',
//                       hintStyle: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                       obscureText: _obscurePassword,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a password';
//                         }
//                         if (value.length < 6) {
//                           return 'Password must be at least 6 characters long';
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 20),

//                     // ---------- CONFIRM PASSWORD ----------
//                     CustomTextField(
//                       controller: _confirmPasswordController,
//                       labelText: 'Confirm Password',
//                       hintText: 'Re-enter password',
//                       hintStyle: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                       obscureText: _obscureConfirmPassword,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureConfirmPassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscureConfirmPassword = !_obscureConfirmPassword;
//                           });
//                         },
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please confirm the password';
//                         }
//                         if (value != _newPasswordController.text) {
//                           return 'Passwords do not match';
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 20),

//                     Center(
//                       child: TextButton(
//                         onPressed: () {
//                           print("Try another way pressed");
//                         },
//                         child: const Text(
//                           'Try another way',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // ---------- Continue Button ----------
//                     SignInCustom(
//                       text: 'Continue',
//                       isSmallScreen: isSmallScreen,
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Password changed successfully'),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               // ---------------------- FORM END ----------------------
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/settings_chnage_password/contrlloer/contrlloer.dart';
import 'package:vocality_ai/widget/color/apps_color.dart';
import 'package:vocality_ai/widget/custom/custom_text_field.dart';
import 'package:vocality_ai/widget/custom/sign_in_custom.dart';

class SettingsChnagePassword extends StatefulWidget {
  const SettingsChnagePassword({Key? key}) : super(key: key);

  @override
  State<SettingsChnagePassword> createState() => _SettingsChnagePasswordState();
}

class _SettingsChnagePasswordState extends State<SettingsChnagePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Get token from secure storage
      final token = await StorageHelper.getToken();

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final success = await authProvider.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmPasswordController.text,
        token: token,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authProvider.errorMessage ?? 'Failed to change password',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: AppColors.goldenYellow,
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- Back Button ----------
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
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
                        Expanded(
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 26 : 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
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

                    // ---------- CURRENT PASSWORD ----------
                    CustomTextField(
                      controller: _currentPasswordController,
                      labelText: 'Current Password',
                      hintText: 'Enter password',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      obscureText: _obscureCurrentPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // ---------- NEW PASSWORD ----------
                    CustomTextField(
                      controller: _newPasswordController,
                      labelText: 'New Password',
                      hintText: 'Enter password',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      obscureText: _obscureNewPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        if (value == _currentPasswordController.text) {
                          return 'New password must be different from current';
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
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
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
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // ---------- Continue Button ----------
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return SignInCustom(
                          text: authProvider.isLoading
                              ? 'Loading...'
                              : 'Continue',
                          isSmallScreen: isSmallScreen,
                          onPressed: authProvider.isLoading
                              ? () {}
                              : _handleChangePassword,
                        );
                      },
                    ),
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
