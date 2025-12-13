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
//         color: Color(0xFFFFFFFF),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             // Profile Header
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context); // Close drawer first
//                 context.push(AppPath.profileDashboard);
//               },
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
//                 child: Column(
//                   children: [
//                     // Profile Avatar
//                     Container(
//                       width: 60,
//                       height: 60,
//                       // decoration: const BoxDecoration(
//                       //   color: Colors.amber,
//                       //   shape: BoxShape.circle,
//                       // ),
//                       child: Image.asset(Assets.icons.profilePng.path),
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

//             // Menu Items
//             _buildMenuItem(
//               icon: Assets.icons.subscriptions.path,
//               title: 'Subscriptions',
//               onTap: () {
//                 Navigator.pop(context); // Close drawer
//                 context.push(AppPath.purchaseScreen);
//               },
//             ),
//             _buildMenuItem(
//               icon: Assets.icons.timePackages.path,
//               title: 'Time Packages',
//               onTap: () {
//                 Navigator.pop(context);
//                 // Add your time packages navigation here
//                 // context.push(AppPath.timePackagesScreen);
//               },
//             ),
//             _buildMenuItem(
//               icon: Assets.icons.imageAiAnalysis.path,
//               title: 'Image-AI Analysis',
//               onTap: () {
//                 Navigator.pop(context); // Close drawer
//                 context.push(AppPath.imageAnalysisScreen);
//               },
//             ),
//             _buildMenuItem(
//               icon: Assets.icons.profileDrawer.path,
//               title: 'Profile',
//               onTap: () {
//                 Navigator.pop(context); // Close drawer
//                 context.push(AppPath.profileDashboard);
//               },
//             ),

//             const SizedBox(height: 10),

//             // Log Out
//             _buildMenuItem(
//               icon: Icons.logout,
//               iconColor: Colors.amber,
//               title: 'Log Out',
//               onTap: () {
//                 Navigator.pop(context);
//                 // Handle log out logic here
//                 // Example: context.go(AppPath.logInScreen);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required String icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(width: 36, height: 36, child: Icon(icon, size: 20)),
//       title: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 15,
//           color: Colors.black87,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       onTap: onTap,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/routing/app_path.dart';
import 'package:vocality_ai/widget/text/text.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFFFFFFF),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ==========================
            // Profile Header
            // ==========================
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context.push(AppPath.profileDashboard);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 60,
                      height: 60,
                      child: Image.asset(Assets.icons.profile.path),
                    ),
                    const SizedBox(height: 12),

                    // Name
                    Text('Istiak Ahmed', style: MyTextStyles.poppinsBold),

                    const SizedBox(height: 4),

                    // Email
                    Text(
                      'istiakahmad@gmail.com',
                      style: MyTextStyles.email_10_w400,
                    ),
                  ],
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
              onTap: () {
                context.pop();
                // context.go(AppPath.logInScreen);
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
