// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:vocality_ai/screen/routing/app_path.dart';

// class ProfileDrawer extends StatelessWidget {
//   const ProfileDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: Colors.white,
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             // Profile Header
//             GestureDetector(
//               onTap: () {
//                 context.push('/profileDashboard');
//                 // Handle navigation to profile dashboard
//               },
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
//                 child: Column(
//                   children: [
//                     // Profile Avatar
//                     Container(
//                       width: 60,
//                       height: 60,
//                       decoration: const BoxDecoration(
//                         color: Colors.amber,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.person,
//                         color: Colors.white,
//                         size: 32,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     // Name
//                     const Text(
//                       'Istiak Ahmed',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     // Email
//                     const Text(
//                       'istiakahmad@gmail.com',
//                       style: TextStyle(fontSize: 13, color: Colors.black45),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Menu Items
//             GestureDetector(
//               onTap: () {
//                 context.push(AppPath.purchaseScreen);
//                 // Handle navigation
//               },
//               child: _buildMenuItem(
//                 icon: Icons.card_membership,
//                 iconColor: Colors.amber,
//                 title: 'Subscriptions',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Handle navigation
//                 },
//               ),
//             ),
//             _buildMenuItem(
//               icon: Icons.access_time,
//               iconColor: Colors.amber,
//               title: 'Time Packages',
//               onTap: () {
//                 Navigator.pop(context);
//                 // Handle navigation
//               },
//             ),
//             GestureDetector(
//               onTap: () {
//                 context.push('/imageAnalysisScreen');
//               },
//               child: _buildMenuItem(
//                 icon: Icons.image,
//                 iconColor: Colors.amber,
//                 title: 'Image-AI Analysis',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Handle navigation
//                 },
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 context.push('/profileDashboard');
//               },
//               child: _buildMenuItem(
//                 icon: Icons.person,
//                 iconColor: Colors.amber,
//                 title: 'Profile',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Handle navigation
//                 },
//               ),
//             ),

//             const SizedBox(height: 10),

//             // Log Out
//             _buildMenuItem(
//               icon: Icons.logout,
//               iconColor: Colors.amber,
//               title: 'Log Out',
//               onTap: () {
//                 Navigator.pop(context);
//                 // Handle log out
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required Color iconColor,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(
//         width: 36,
//         height: 36,
//         decoration: BoxDecoration(
//           color: iconColor.withOpacity(0.1),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, color: iconColor, size: 20),
//       ),
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
import 'package:vocality_ai/screen/routing/app_path.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Profile Header
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close drawer first
                context.push(AppPath.profileDashboard);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Name
                    const Text(
                      'Istiak Ahmed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Email
                    const Text(
                      'istiakahmad@gmail.com',
                      style: TextStyle(fontSize: 13, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ),

            // Menu Items
            _buildMenuItem(
              icon: Icons.card_membership,
              iconColor: Colors.amber,
              title: 'Subscriptions',
              onTap: () {
                Navigator.pop(context); // Close drawer
                context.push(AppPath.purchaseScreen);
              },
            ),
            _buildMenuItem(
              icon: Icons.access_time,
              iconColor: Colors.amber,
              title: 'Time Packages',
              onTap: () {
                Navigator.pop(context);
                // Add your time packages navigation here
                // context.push(AppPath.timePackagesScreen);
              },
            ),
            _buildMenuItem(
              icon: Icons.image,
              iconColor: Colors.amber,
              title: 'Image-AI Analysis',
              onTap: () {
                Navigator.pop(context); // Close drawer
                context.push(AppPath.imageAnalysisScreen);
              },
            ),
            _buildMenuItem(
              icon: Icons.person,
              iconColor: Colors.amber,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context); // Close drawer
                context.push(AppPath.profileDashboard);
              },
            ),

            const SizedBox(height: 10),

            // Log Out
            _buildMenuItem(
              icon: Icons.logout,
              iconColor: Colors.amber,
              title: 'Log Out',
              onTap: () {
                Navigator.pop(context);
                // Handle log out logic here
                // Example: context.go(AppPath.logInScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
