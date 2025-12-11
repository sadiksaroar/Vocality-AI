import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextStyles {
  static final heading = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static final subHeading = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey[700],
    height: 1.5,
  );

  static final button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final labelText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF151515),
    height: 1.8,
  );

  static final input = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );
  // User name / small text
  static final userName = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF595959),
    height: 1.7,
  );
}
