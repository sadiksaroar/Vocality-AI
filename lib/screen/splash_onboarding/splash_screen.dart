import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocality_ai/widget/brand_widget.dart';
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
      // ignore: use_build_context_synchronously
      context.push('/microphonePermissionScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellowAmber,
      body: Center(child: BrandWidget(width: 150, height: 150)),
    );
  }
}
