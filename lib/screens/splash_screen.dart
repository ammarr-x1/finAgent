import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';
import '../widgets/typewriter_text.dart';
import 'app_shell.dart';

// ==========================================
// SCREEN 1 — SPLASH SCREEN
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double _loadingProgress = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 40.0, end: 70.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Simulate Agent Initialization progress
    _progressTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        if (_loadingProgress < 1.0) {
          _loadingProgress += 0.01;
        } else {
          _progressTimer?.cancel();
          _navigateToDashboard();
        }
      });
    });
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AppShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsing Neon Logo
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.darkSurface,
                      border: Border.all(
                        color: AppColors.electricCyan.withOpacity(0.8),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.electricCyan.withOpacity(0.3),
                          blurRadius: _pulseAnimation.value,
                          spreadRadius: _pulseAnimation.value * 0.15,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.hub_rounded,
                      color: AppColors.electricCyan,
                      size: 44,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Typewriter Logo text
              TypewriterText(
                text: "FinAgent",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              FadeInUp(
                duration: const Duration(seconds: 1),
                delay: const Duration(milliseconds: 500),
                child: Text(
                  "AUTONOMOUS FINANCIAL INTELLIGENCE",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.electricCyan,
                  ),
                ),
              ),
              const SizedBox(height: 80),
              // Loading Progress Indicator
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _loadingProgress,
                        backgroundColor: AppColors.darkSurface,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.electricCyan),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Initializing AI Agents... ${(_loadingProgress * 100).toInt()}%",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

