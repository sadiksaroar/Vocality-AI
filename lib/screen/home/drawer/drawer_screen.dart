// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:vocality_ai/core/gen/assets.gen.dart';
// import 'package:vocality_ai/screen/routing/app_path.dart';
// import 'package:vocality_ai/widget/text/text.dart';

// class ProfileDrawer extends StatelessWidget {
//   const ProfileDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: const Color(0xFFFFFFFF),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             // ==========================
//             // Profile Header
//             // ==========================
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//                 context.push(AppPath.profileDashboard);
//               },
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
//                 child: Column(
//                   children: [
//                     // Avatar
//                     Container(
//                       width: 60,
//                       height: 60,
//                       child: Image.asset(Assets.icons.profile.path),
//                     ),
//                     const SizedBox(height: 12),

//                     // Name
//                     Text('Istiak Ahmed', style: MyTextStyles.poppinsBold),

//                     const SizedBox(height: 4),

//                     // Email
//                     Text(
//                       'istiakahmad@gmail.com',
//                       style: MyTextStyles.email_10_w400,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // ==========================
//             // Menu Items
//             // ==========================
//             _buildMenuItem(
//               icon: Assets.icons.subscriptions.path,
//               title: 'Subscriptions',
//               onTap: () {
//                 Navigator.pop(context);
//                 context.push(AppPath.purchaseScreen);
//               },
//             ),

//             _buildMenuItem(
//               icon: Assets.icons.timePackages.path,
//               title: 'Time Packages',
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),

//             _buildMenuItem(
//               icon: Assets.icons.imageAIAnalysis.path,
//               title: 'Image-AI Analysis',
//               onTap: () {
//                 Navigator.pop(context);
//                 context.push(AppPath.imageAnalysisScreen);
//               },
//             ),

//             _buildMenuItem(
//               icon: Assets.icons.profileDrawer.path,
//               title: 'Profile',
//               onTap: () {
//                 Navigator.pop(context);
//                 context.push(AppPath.profileDashboard);
//               },
//             ),

//             const SizedBox(height: 10),

//             // ==========================
//             // Logout
//             // ==========================
//             _buildMenuItem(
//               icon: Assets.icons.logOut.path,
//               title: 'Log Out',
//               onTap: () {
//                 context.pop();
//                 // context.go(AppPath.logInScreen);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ======================================================
//   // Reusable Menu Item (supports both Image Assets & Icons)
//   // ======================================================
//   Widget _buildMenuItem({
//     required dynamic icon, // String (asset) or IconData
//     required String title,
//     required VoidCallback onTap,
//     Color? iconColor,
//   }) {
//     return ListTile(
//       leading: SizedBox(
//         width: 36,
//         height: 36,
//         child: icon is String
//             ? Image.asset(icon) // Asset image
//             : Icon(icon, size: 22, color: iconColor), // Material icon
//       ),
//       title: Text(title, style: MyTextStyles.subscription),
//       onTap: onTap,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/home/drawer/personalty/personalty_model.dart';
import 'package:vocality_ai/screen/home/drawer/personalty/profile_servic.dart';
import 'package:vocality_ai/screen/routing/app_path.dart';
import 'package:vocality_ai/widget/text/text.dart';

import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  // static const String _baseUrl = 'http://10.10.7.74:8000';
  static const String _baseUrl = AppConfig.httpBase;

  @override
  Widget build(BuildContext context) {
    final Future<UserModel> profileFuture = ProfileService().fetchProfile();

    return Drawer(
      child: Container(
        color: const Color(0xFFFFFFFF),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ==========================
            // Profile Header (dynamic)
            // ==========================
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context.push(AppPath.profileDashboard);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                child: FutureBuilder<UserModel>(
                  future: profileFuture,
                  builder: (context, snapshot) {
                    Widget avatar = SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset(Assets.icons.profile.path),
                    );
                    String name = 'User';
                    String email = '';

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      name = 'Loading...';
                    } else if (snapshot.hasError) {
                      name = 'Unknown';
                    } else if (snapshot.hasData) {
                      final user = snapshot.data!;
                      name = user.name;
                      email = user.email;
                      if (user.image != null && user.image!.isNotEmpty) {
                        final imgUrl = user.image!.startsWith('http')
                            ? user.image!
                            : '$_baseUrl${user.image}';
                        avatar = ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            imgUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Image.asset(
                                Assets.icons.profile.path,
                                width: 60,
                                height: 60,
                              );
                            },
                          ),
                        );
                      }
                    }

                    return Column(
                      children: [
                        // Avatar
                        Container(width: 60, height: 60, child: avatar),
                        const SizedBox(height: 12),

                        // Name
                        Text(name, style: MyTextStyles.poppinsBold),

                        const SizedBox(height: 4),

                        // Email
                        Text(
                          email.isNotEmpty ? email : 'No email',
                          style: MyTextStyles.email_10_w400,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ==========================
            // Menu Items
            // ==========================
            _buildMenuItem(
              icon: Assets.icons.subscriptions.path,
              title: 'Subscriptions',
              onTap: () {
                Navigator.pop(context);
                context.push(AppPath.purchaseScreen);
              },
            ),

            _buildMenuItem(
              icon: Assets.icons.timePackages.path,
              title: 'Time Packages',
              onTap: () {
                Navigator.pop(context);
              },
            ),

            _buildMenuItem(
              icon: Assets.icons.imageAIAnalysis.path,
              title: 'Image-AI Analysis',
              onTap: () {
                Navigator.pop(context);
                context.push(AppPath.imageAnalysisScreen);
              },
            ),

            _buildMenuItem(
              icon: Assets.icons.profileDrawer.path,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context);
                context.push(AppPath.profileDashboard);
              },
            ),

            const SizedBox(height: 10),

            // ==========================
            // Logout
            // ==========================
            _buildMenuItem(
              icon: Assets.icons.logOut.path,
              title: 'Log Out',
              onTap: () async {
                await StorageHelper.clearAll();
                context.go(AppPath.logInScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // Reusable Menu Item (supports both Image Assets & Icons)
  // ======================================================
  Widget _buildMenuItem({
    required dynamic icon, // String (asset) or IconData
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: SizedBox(
        width: 36,
        height: 36,
        child: icon is String
            ? Image.asset(icon) // Asset image
            : Icon(icon, size: 22, color: iconColor), // Material icon
      ),
      title: Text(title, style: MyTextStyles.subscription),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
