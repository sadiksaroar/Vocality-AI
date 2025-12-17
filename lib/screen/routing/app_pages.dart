import 'package:go_router/go_router.dart';
import 'package:vocality_ai/screen/auth/forget_password_screen.dart';
import 'package:vocality_ai/screen/auth/log_in_Screen.dart';
import 'package:vocality_ai/screen/auth/otp_verify_screen.dart';
import 'package:vocality_ai/screen/auth/password_chnage_screen.dart';
import 'package:vocality_ai/screen/auth/resent_otp_screen.dart';
import 'package:vocality_ai/screen/auth/sign_in_screen.dart';
import 'package:vocality_ai/screen/home/drawer/profile_dashboard/profile_dashboard.dart';
import 'package:vocality_ai/screen/home/drawer/purchase_screen/purchase_screen.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/setting_screen.dart';
import 'package:vocality_ai/screen/home/drawer/setting_screen.dart/settings_chnage_password/settings_chnage_password.dart';
import 'package:vocality_ai/screen/home/home_screen/home_screen.dart';
import 'package:vocality_ai/screen/home/image_analysis_screen/image_analysis_screen.dart';
import 'package:vocality_ai/screen/routing/app_path.dart';
import 'package:vocality_ai/screen/splash_onboarding/micrio_phone_acces.dart';
import 'package:vocality_ai/screen/splash_onboarding/splash_screen.dart';
import 'package:vocality_ai/screen/splash_onboarding/tap_to_start.dart';

class AppPages {
  static final GoRouter router = GoRouter(
    initialLocation: AppPath.splashScreen,
    routes: [
      GoRoute(
        path: AppPath.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppPath.microphonePermissionScreen,
        builder: (context, state) => const MicrophonePermissionScreen(),
      ),
      GoRoute(
        path: AppPath.tapToStart,
        builder: (context, state) => const TapToStart(),
      ),
      /*  auth part start     */
      GoRoute(
        path: AppPath.signInScreen,
        builder: (context, state) {
          return const SignInScreen();
        },
      ),

      GoRoute(
        path: AppPath.otpVerifyScreen,
        builder: (context, state) {
          final email =
              state.extra as String?; // Pass email from previous screen
          return OtpVerifyScreen(email: email);
        },
      ),

      GoRoute(
        path: AppPath.logInScreen,
        builder: (context, state) {
          // Replace with your LogInScreen widget
          return const LogInScreen();
        },
      ),

      GoRoute(
        path: AppPath.forgetPasswordScreen,
        builder: (context, state) {
          // Replace with your ForgotPasswordScreen widget
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: AppPath.resentOtpScreen,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?['email'] as String? ?? '';
          return ResentOtpScreen(email: email);
        },
      ),

      GoRoute(
        path: AppPath.passwordChangeScreen,
        builder: (context, state) {
          // Replace with your PasswordChangeScreen widget
          return const PasswordChnageScreen();
        },
      ),
      // GoRoute(
      //   path: '/password-change/:token',
      //   builder: (context, state) {
      //     final token = state.pathParameters['token']!;
      //     return PasswordChnageScreen(resetToken: token);
      //   },
      // ),

      /*  auth part end      */
      /*  home part start     */
      GoRoute(
        path: AppPath.homeScreen,
        builder: (context, state) {
          // Replace with your HomeScreen widget
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppPath.profileDashboard,
        builder: (context, state) {
          // Replace with your ProfileDashboard widget
          return const ProfileDashboard();
        },
      ),
      GoRoute(
        path: AppPath.settingsSettingsScreen,
        builder: (context, state) {
          // Replace with your SettingsScreen widget
          return const SettingsScreen();
        },
      ),
      GoRoute(
        path: AppPath.settingsChangePassword,
        builder: (context, state) {
          // Replace with your SettingsChangePassword widget
          return const SettingsChnagePassword();
        },
      ),
      GoRoute(
        path: AppPath.purchaseScreen,
        builder: (context, state) {
          // Replace with your PurchaseScreen widget
          return const PurchaseScreen();
        },
      ),

      GoRoute(
        path: AppPath.imageAnalysisScreen,
        builder: (context, state) {
          // Replace with your ImageAnalysisScreen widget
          return const ImageAnalysisScreen();
        },
      ),
    ],
  );
}
