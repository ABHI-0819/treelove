import 'package:flutter/material.dart';
import 'app_color.dart'; // Ensure you import your color constants here

class AppButtonStyle {
  AppButtonStyle._();

  static final ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColor.primary, // #00473C
    foregroundColor: AppColor.background, // #F8F4E3 for text
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
    textStyle: const TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
  );

  static final ButtonStyle secondary = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF115D41), // Darker shade of green
    foregroundColor: AppColor.white, // White text
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    textStyle: const TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
  );
}
