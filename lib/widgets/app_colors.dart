import 'package:flutter/material.dart';

class AppColors {
  static const primaryBlue = Color(0xFF667EEA);
  static const deepBlue = Color(0xFF764BA2);
  static const successGreen = Color(0xFF10B981);
  static const brightOrange = Color(0xFFF59E0B);
  static const warningRed = Color(0xFFEF4444);
  static const lightGray = Color(0xFFF8FAFC);
  static const mediumGray = Color(0xFF64748B);
  static const darkGray = Color(0xFF1F2937);
  static const primaryGradient = LinearGradient(
    colors: [primaryBlue, deepBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFF3B5998), Color(0xFFD62C22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
