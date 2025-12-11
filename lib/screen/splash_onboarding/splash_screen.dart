import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/widget/color/apps_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      context.push('/microphonePermissionScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellowAmber,
      body: Center(child: Assets.icons.k.image(width: 150, height: 150)),
    );
  }
}
