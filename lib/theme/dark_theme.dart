import 'package:dusto/theme/custom_theme_colors.dart';
import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  // ===== 🟡 Dusto Primary Color (Yellow) =====
  primaryColor: // Dusto Bright Yellow
  Color.fromARGB(
    255,
    255,
    238,
    52,
  ), // D
  // Light tint of yellow for specific highlights
  primaryColorLight: const Color(0xFFFFF9C4),

  // Darker Amber/Gold for contrast/gradients
  primaryColorDark: Color(0xFFFFEC00), //

  secondaryHeaderColor: const Color(0xFF9BB8DA),
  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xFF151515),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFC0BFBF),
  focusColor: const Color(0xFF484848),
  hoverColor: const Color(0x400461A5),
  shadowColor: const Color(0x33e2f1ff),
  cardColor: const Color(0xFF10324A),
  extensions: <ThemeExtension<CustomThemeColors>>[CustomThemeColors.dark()],

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white),
  ),
  colorScheme: const ColorScheme.dark(
    // ===== 🟡 Dusto Primary Color =====
    primary: Color(0xFFFFEC00), //
    secondary: Color(0xFFFFEC00),
    onSecondary: Color.fromARGB(255, 255, 238, 52), // D
    onSecondaryContainer: Color.fromARGB(255, 2, 170, 5),
    tertiary: (Color(0xFFFF6767)),
    error: (Color(0xFFBC4040)),

    // ===== ⚫ Black text on Yellow buttons for readability =====
    onPrimary: Colors.black,
  ).copyWith(surface: const Color(0xff010D15)),
);
