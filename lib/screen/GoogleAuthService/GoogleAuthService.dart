// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:vocality_ai/core/storage_helper.dart';

// class GoogleAuthService {
//   static const String _baseUrl = 'http://10.10.7.74:8000';
  
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'profile'],
//   );

//   Future<bool> signInWithGoogle() async {
//     try {
//       // Sign in with Google
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return false;

//       // Get authentication
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final String? accessToken = googleAuth.accessToken;

//       if (accessToken == null) return false;

//       // Send to backend
//       final response = await http.post(
//         Uri.parse('$_baseUrl/accounts/user/dj-rest-auth/google/'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'access_token': accessToken}),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
        
//         // Save tokens and user info
//         await StorageHelper.saveToken(data['access_token']);
//         await StorageHelper.saveRefreshToken(data['refresh_token']);
//         await StorageHelper.saveEmail(googleUser.email);
        
//         // Save premium status if available
//         if (data['user'] != null && data['user']['is_premium'] != null) {
//           await StorageHelper.setPremiumStatus(data['user']['is_premium']);
//         }
        
//         return true;
//       }
      
//       return false;
//     } catch (e) {
//       print('Google Sign-In Error: $e');
//       return false;
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//   }
// }