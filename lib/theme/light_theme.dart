import 'package:dusto/theme/custom_theme_colors.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  // ===== 🟡 Dusto Primary Color (Yellow) =====
  primaryColor: Color(0xFFFFEC00), // Dusto Bright Yellow
  // Light tint of yellow
  primaryColorLight: const Color(0xFFFFF9C4),

  // Darker Amber for contrast
  primaryColorDark: Color.fromARGB(255, 255, 234, 0),

  secondaryHeaderColor: const Color(0xFF758493),
  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  brightness: Brightness.light,
  hintColor: const Color(0xFFA4A4A4),
  focusColor: const Color(0xFFFFF9E5),
  hoverColor: const Color(0xFFF8FAFC),
  shadowColor: const Color(0xFFE6E5E5),
  cardColor: Colors.white,
  primaryTextTheme: TextTheme(
    titleMedium: TextStyle(color: Colors.yellow.shade800),
  ),

  textButtonTheme: TextButtonThemeData(
    // Using the darker yellow for text buttons so they are visible on white
    style: TextButton.styleFrom(foregroundColor: Colors.black),
  ),
  extensions: <ThemeExtension<CustomThemeColors>>[CustomThemeColors.light()],

  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFFEC00),
    secondary: Color(0xFFFFEC00),
    onSecondary: Color.fromARGB(255, 255, 234, 0), // D
    tertiary: Color(0xFFd35221),
    onSecondaryContainer: Color.fromARGB(255, 243, 255, 19),
    error: Color(0xFFf76767),

    // ===== ⚫ Black text on Yellow buttons (Critical for readability) =====
    onPrimary: Colors.black,
  ).copyWith(surface: const Color(0xffFCFCFC)),
);
