import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

// ==========================================
// Theme & Style Constants
// ==========================================
class AppColors {
  // Dark theme
  static const darkBg = Color(0xFF0A0E1A);
  static const darkCard = Color(0xFF111827);
  static const darkSurface = Color(0xFF1C2333);

  // Light theme
  static const lightBg = Color(0xFFF0F4FF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFE8EDF8);
  static const lightText = Color(0xFF0A0E1A);

  // Constants (Same in both themes)
  static const electricCyan = Color(0xFF00D4FF);
  static const neonGreen = Color(0xFF00FF88);
  static const warningAmber = Color(0xFFFFB800);
  static const dangerRed = Color(0xFFFF4757);

  // Text secondary
  static const greyText = Color(0xFF9CA3AF);
  static const greyTextLight = Color(0xFF4B5563);
}

// Global Notifier for Theme Mode
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier(ThemeMode.dark);

class FinAgentApp extends StatelessWidget {
  const FinAgentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'FinAgent',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.darkBg,
            cardColor: AppColors.darkCard,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.electricCyan,
              secondary: AppColors.neonGreen,
              surface: AppColors.darkSurface,
              background: AppColors.darkBg,
            ),
            textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          ),
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.lightBg,
            cardColor: AppColors.lightCard,
            colorScheme: const ColorScheme.light(
              primary: AppColors.electricCyan,
              secondary: AppColors.neonGreen,
              surface: AppColors.lightSurface,
              background: AppColors.lightBg,
            ),
            textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

