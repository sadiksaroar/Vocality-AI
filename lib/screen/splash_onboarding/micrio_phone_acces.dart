import 'package:flutter/material.dart';
import 'package:vocality_ai/widget/color/apps_color.dart';
import 'package:vocality_ai/widget/custom/custom_button.dart';
import 'package:vocality_ai/widget/text/text.dart';

class MicrophonePermissionScreen extends StatelessWidget {
  const MicrophonePermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellowAmber,
      body: Container(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Microphone Icon Circle
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.mic_outlined,
                      size: 48,
                      color: Color(0xFF9CA3AF), // gray-400
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Allow Microphone Access',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827), // gray-900
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'VoiceChat needs access to your microphone to enable voice conversations with your AI assistant.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1F2937), // gray-800
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 48),
                  CustomButton(
                    text: 'Allow Microphone',
                    onPressed: () => _handleAllowMicrophone(context),
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                  ),

                  const SizedBox(height: 16),

                  // Maybe Later Link
                  TextButton(
                    onPressed: () {
                      // Handle skip
                      _handleMaybeLater(context);
                    },
                    child: const Text(
                      'Maybe Later',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151), // gray-700
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAllowMicrophone(BuildContext context) {
    // Add your permission request logic here
    // Example: Permission.microphone.request();
    print('Microphone permission requested');
  }

  void _handleMaybeLater(BuildContext context) {
    // Add your skip logic here
    print('Permission skipped');
    Navigator.pop(context);
  }
}

// Example usage in main.dart:
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'VoiceChat',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.yellow,
//       ),
//       home: const MicrophonePermissionScreen(),
//     );
//   }
// }
