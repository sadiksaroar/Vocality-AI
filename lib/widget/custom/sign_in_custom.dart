import 'package:flutter/material.dart';

class SignInCustom extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double? fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double elevation;
  final bool isSmallScreen;

  const SignInCustom({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.borderRadius = 30,
    this.elevation = 0,
    this.isSmallScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
        padding: padding,
        minimumSize: const Size.fromHeight(60), // 👈 FIXED HEIGHT
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? (isSmallScreen ? 16 : 18),
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
