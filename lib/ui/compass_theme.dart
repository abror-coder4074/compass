import 'package:flutter/material.dart';

abstract final class CompassAssets {
  static const certiportLogo = 'assets/images/certiport_logo.png';
  static const ic3Logo = 'assets/images/ic3_logo.png';
  static const examLandingPhoto = 'assets/images/exam_landing_photo.png';
}

abstract final class CompassColors {
  static const certiportTeal = Color(0xFF0789A2);
  static const certiportTealDark = Color(0xFF006F86);
  static const examNavy = Color(0xFF003D66);
  static const darkNavy = Color(0xFF003659);
  static const portalBackground = Color(0xFFE9E9E9);
  static const examHeader = Color(0xFFEAF1F8);
  static const border = Color(0xFFD7D7D7);
  static const fieldBorder = Color(0xFFCFCFCF);
  static const text = Color(0xFF263442);
  static const mutedText = Color(0xFF66727D);
  static const warning = Color(0xFFF5A623);
  static const successGreen = Color(0xFF2FAF2D);
  static const ic3Green = Color(0xFF31AA2D);
}

ThemeData buildCompassTheme() {
  final base = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Arial',
    scaffoldBackgroundColor: CompassColors.portalBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: CompassColors.certiportTeal,
      primary: CompassColors.certiportTeal,
      secondary: CompassColors.examNavy,
      surface: Colors.white,
    ),
    useMaterial3: false,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: CompassColors.text,
      displayColor: CompassColors.text,
      fontFamily: 'Arial',
    ),
    dividerColor: CompassColors.border,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: CompassColors.fieldBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: CompassColors.fieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: CompassColors.certiportTeal, width: 1.5),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: CompassColors.text,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        color: CompassColors.text,
        fontSize: 14,
        height: 1.35,
      ),
    ),
  );
}
