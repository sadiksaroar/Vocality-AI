// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:vocality_ai/core/gen/assets.gen.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   void showDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Container(
//             width: 327,
//             height: 201,
//             decoration: ShapeDecoration(
//               color: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   left: 30,
//                   top: 36,
//                   child: Container(
//                     width: 268,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       spacing: 28,
//                       children: [
//                         SizedBox(
//                           width: 268,
//                           child: Text(
//                             'Are you sure you want to delete your account?',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 18,
//                               fontFamily: 'SF Pro Display',
//                               fontWeight: FontWeight.w500,
//                               height: 1.50,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: double.infinity,
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             spacing: 12,
//                             children: [
//                               // NO Button
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).pop(); // Close dialog
//                                 },
//                                 child: Container(
//                                   width: 125.31,
//                                   height: 47,
//                                   decoration: ShapeDecoration(
//                                     color: const Color(0xFFE5E7EB),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                         41073000,
//                                       ),
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'NO',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: const Color(0xFF101727),
//                                         fontSize: 16,
//                                         fontFamily: 'SF Pro Display',
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // YES Button
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).pop(); // Close dialog
//                                   // Add your account deletion logic here
//                                   // For example:
//                                   // deleteUserAccount();
//                                   // context.go('/login');
//                                 },
//                                 child: Container(
//                                   width: 125.31,
//                                   height: 47,
//                                   decoration: ShapeDecoration(
//                                     color: const Color(0xFFE7000B),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                         41073000,
//                                       ),
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'YES',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontFamily: 'SF Pro Display',
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFD500),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     child: IconButton(
//                       icon: Image.asset(
//                         Assets.icons.backIcon.path,
//                         width: 24,
//                         height: 24,
//                       ),
//                       onPressed: () => Navigator.of(context).pop(),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   const Text(
//                     'Settings',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: () {
//                       context.push("/SettingsChangePassword");
//                     },
//                     borderRadius: BorderRadius.circular(16),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 18,
//                       ),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             Assets.icons.setting.path,
//                             width: 22,
//                             height: 22,
//                           ),
//                           const SizedBox(width: 16),
//                           const Expanded(
//                             child: Text(
//                               'Change Password',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             color: Colors.grey[400],
//                             size: 18,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: () {
//                       showDeleteDialog(context);
//                     },
//                     borderRadius: BorderRadius.circular(16),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 18,
//                       ),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             Assets.icons.deleteAccount.path,
//                             width: 22,
//                             height: 22,
//                           ),
//                           const SizedBox(width: 16),
//                           const Expanded(
//                             child: Text(
//                               'Delete Account',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
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
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/settings_chnage_password/delate_account/account_controller.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/settings_chnage_password/delate_account/account_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void showDeleteDialog(BuildContext context) {
    final controller = AccountController(AccountService());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 327,
            height: 201,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 36, 30, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Are you sure you want to delete your account?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(dialogCtx).pop();
                          },
                          child: Container(
                            height: 47,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE5E7EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'NO',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF101727),
                                  fontSize: 16,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.of(
                              dialogCtx,
                            ).pop(); // close confirm dialog

                            // show loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            try {
                              final token = await controller.getAuthToken();
                              if (token == null || token.isEmpty) {
                                Navigator.of(context).pop(); // close loading
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Auth token missing'),
                                  ),
                                );
                                return;
                              }

                              final success = await controller.deleteAccount(
                                token,
                              );
                              Navigator.of(context).pop(); // close loading

                              if (success) {
                                // navigate to login (adjust route if needed)
                                context.go('/login');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to delete account'),
                                  ),
                                );
                              }
                            } catch (e) {
                              Navigator.of(context).pop(); // close loading
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 47,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE7000B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'YES',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD500),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      Assets.icons.backIcon.path,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.push("/SettingsChangePassword");
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.icons.setting.path,
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showDeleteDialog(context);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.icons.deleteAccount.path,
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Delete Account',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
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

// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/settings_chnage_password/delate_account/account_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void showDeleteDialog(BuildContext context) {
    final AccountController accountController = Get.put(AccountController());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 327,
            height: 201,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 36, 30, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Are you sure you want to delete your account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      // NO Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(dialogCtx).pop(); // Close dialog
                          },
                          child: Container(
                            height: 47,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE5E7EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'NO',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF101727),
                                  fontSize: 16,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // YES Button
                      Expanded(
                        child: Obx(
                          () => GestureDetector(
                            onTap: accountController.isLoading.value
                                ? null
                                : () async {
                                    Navigator.of(
                                      dialogCtx,
                                    ).pop(); // Close confirm dialog

                                    // Show loading dialog
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (loadingCtx) => const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFFFD500),
                                        ),
                                      ),
                                    );

                                    // Delete account
                                    final success = await accountController
                                        .deleteAccount();

                                    // Close loading dialog if still open
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }

                                    // Show result via ScaffoldMessenger and navigate if needed
                                    if (context.mounted) {
                                      if (success) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Account deleted successfully',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        // navigate to login
                                        await Future.delayed(
                                          const Duration(milliseconds: 500),
                                        );
                                        context.go('/login');
                                      } else {
                                        final message =
                                            accountController
                                                .errorMessage
                                                .value
                                                .isNotEmpty
                                            ? accountController
                                                  .errorMessage
                                                  .value
                                            : 'Failed to delete account';
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(message),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                            child: Container(
                              height: 47,
                              decoration: ShapeDecoration(
                                color: accountController.isLoading.value
                                    ? const Color(0xFFE7000B).withOpacity(0.5)
                                    : const Color(0xFFE7000B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                              ),
                              child: Center(
                                child: accountController.isLoading.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'YES',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'SF Pro Display',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD500),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      Assets.icons.backIcon.path,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Change Password
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.push("/SettingsChangePassword");
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.icons.setting.path,
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Delete Account
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showDeleteDialog(context);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.icons.deleteAccount.path,
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Delete Account',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
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
