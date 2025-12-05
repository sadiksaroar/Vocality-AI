import 'dart:ui' show TextStyle, FontWeight, Color;

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle medium30 = GoogleFonts.roboto(
    fontWeight: FontWeight.w500,
    fontSize: 30,
    height: 1.0,
    letterSpacing: 0.0,
    color: const Color(0xFF0A0A0A),
  );
  static TextStyle manrope14MediumCenter = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14, // line-height = 20px
    letterSpacing: -0.14, // -1% of 14px
    color: const Color(0xFF838FA0),
  );
}
