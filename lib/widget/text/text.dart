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
  static final subscriptionStatus = GoogleFonts.openSans(
    color: const Color(0xFF1D2838),
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
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
  static final poppinsBold = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF2E2C2C),
  );
  // ignore: non_constant_identifier_names
  static final email_10_w400 = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF999999),
  );
  static final subscription = GoogleFonts.poppins(
    color: const Color(0xFF5C5C5C),
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.40,
  );
}
