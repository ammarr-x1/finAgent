import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

// ==========================================
// Custom Glassmorphic Card
// ==========================================
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final List<Color>? gradientColors;

  const GlassCard({
    Key? key,
    required this.child,
    this.borderRadius = 16.0,
    this.blur = 20.0,
    this.padding = const EdgeInsets.all(16.0),
    this.borderColor,
    this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardOpacity = isDark ? 0.08 : 0.05;
    final color = isDark ? Colors.white : Colors.black;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? color.withOpacity(cardOpacity * 2),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors ??
                  [
                    color.withOpacity(cardOpacity),
                    color.withOpacity(cardOpacity * 0.5),
                  ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

