import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/widget/color/apps_color.dart';
import 'package:vocality_ai/widget/custom/custom_button.dart';

class MicrophonePermissionScreen extends StatelessWidget {
  const MicrophonePermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellowAmber,
      body: SafeArea(
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
                Text(
                  'Allow Microphone Access',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0A0A0A),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'VoiceChat needs access to your microphone to enable voice conversations with your AI assistant.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF495565),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Allow Microphone Button
                CustomButton(
                  text: 'Allow Microphone',
                  onPressed: () {
                    context.push("/tapToStart");
                  },
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.white,
                ),

                const SizedBox(height: 16),

                // Maybe Later Button
                TextButton(
                  onPressed: () {
                    // Handle skip action
                    context.pop(); // OR any route you want
                  },
                  child: Text(
                    'Maybe Later',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF495565),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      decoration: TextDecoration.underline,
                    ),
                    // style: TextStyle(
                    //   fontSize: 14,
                    //   color: Color(0xFF374151), // gray-700
                    //   decoration: TextDecoration.underline,
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
