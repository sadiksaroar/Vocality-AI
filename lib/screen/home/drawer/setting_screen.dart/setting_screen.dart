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
//                               Container(
//                                 width: 125.31,
//                                 height: 47,
//                                 decoration: ShapeDecoration(
//                                   color: const Color(0xFFE5E7EB),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       41073000,
//                                     ),
//                                   ),
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Positioned(
//                                       left: 51,
//                                       top: 14,
//                                       child: Text(
//                                         'NO',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: const Color(0xFF101727),
//                                           fontSize: 16,
//                                           fontFamily: 'SF Pro Display',
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: 125.31,
//                                 height: 47,
//                                 decoration: ShapeDecoration(
//                                   color: const Color(0xFFE7000B),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       41073000,
//                                     ),
//                                   ),
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Positioned(
//                                       left: 47.70,
//                                       top: 14,
//                                       child: Text(
//                                         'YES',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontFamily: 'SF Pro Display',
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
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
//       // appBar: AppBar(
//       //   backgroundColor: const Color(0xFFFFC107),
//       //   elevation: 0,
//       //   leading: IconButton(
//       //     icon: const Icon(Icons.arrow_back, color: Colors.black87),
//       //     onPressed: () => Navigator.of(context).pop(),
//       //   ),
//       // ),
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
//                       // icon: const Icon(Icons.arrow_back, color: Colors.white),
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
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
            child: Stack(
              children: [
                Positioned(
                  left: 30,
                  top: 36,
                  child: Container(
                    width: 268,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 28,
                      children: [
                        SizedBox(
                          width: 268,
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
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 12,
                            children: [
                              // NO Button
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(); // Close dialog
                                },
                                child: Container(
                                  width: 125.31,
                                  height: 47,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFE5E7EB),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        41073000,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'NO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF101727),
                                        fontSize: 16,
                                        fontFamily: 'SF Pro Display',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // YES Button
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(); // Close dialog
                                  // Add your account deletion logic here
                                  // For example:
                                  // deleteUserAccount();
                                  // context.go('/login');
                                },
                                child: Container(
                                  width: 125.31,
                                  height: 47,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFE7000B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        41073000,
                                      ),
                                    ),
                                  ),
                                  child: Center(
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                  Container(
                    child: IconButton(
                      icon: Image.asset(
                        Assets.icons.backIcon.path,
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
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
