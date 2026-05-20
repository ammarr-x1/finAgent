import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';
import '../models/models.dart';
import '../widgets/glass_card.dart';
import '../widgets/pulsing_indicator.dart';
import '../widgets/typewriter_text.dart';
import '../widgets/news_ticker.dart';

// ==========================================
// SCREEN 4 — INSIGHT DETAILS
// ==========================================
class InsightDetailsScreen extends StatelessWidget {
  final VoidCallback onViewTradesTap;

  const InsightDetailsScreen({
    Key? key,
    required this.onViewTradesTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Insight Analysis Details",
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Gradient Card for main insight
              GlassCard(
                borderRadius: 16,
                padding: const EdgeInsets.all(18),
                gradientColors: isDark
                    ? [
                        const Color(0xFF1F2937).withOpacity(0.6),
                        const Color(0xFF111827).withOpacity(0.6),
                      ]
                    : [
                        Colors.white,
                        AppColors.lightSurface,
                      ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "CORE MACRO OBSERVATION",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: AppColors.electricCyan,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.dangerRed.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "CRITICAL IMPACT",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dangerRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Rising oil prices combined with negative transportation sentiment will reduce logistics profitability significantly.",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sentiment Score: -0.76",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dangerRed,
                          ),
                        ),
                        Text(
                          "Sector Correlation: High (93%)",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.greyText
                                : AppColors.greyTextLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Confidence & Affected Sectors Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular Confidence Meter
                  Expanded(
                    flex: 4,
                    child: GlassCard(
                      borderRadius: 14,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            "CONFIDENCE",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.greyText
                                  : AppColors.greyTextLight,
                            ),
                          ),
                          const SizedBox(height: 14),
                          CircularPercentIndicator(
                            radius: 36.0,
                            lineWidth: 7.0,
                            animation: true,
                            percent: 0.91,
                            center: Text(
                              "91%",
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neonGreen,
                              ),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: AppColors.neonGreen,
                            backgroundColor:
                                (isDark ? Colors.white : Colors.black)
                                    .withOpacity(0.08),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "High AI Consensus",
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: AppColors.greyText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Affected Sectors
                  Expanded(
                    flex: 6,
                    child: GlassCard(
                      borderRadius: 14,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AFFECTED SECTORS",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.greyText
                                  : AppColors.greyTextLight,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "NEGATIVE IMPACT",
                            style: GoogleFonts.inter(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dangerRed),
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 6,
                            children: [
                              _buildImpactChip(
                                  "Transportation 🔴", AppColors.dangerRed),
                              _buildImpactChip(
                                  "Logistics 🔴", AppColors.dangerRed),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "POSITIVE IMPACT",
                            style: GoogleFonts.inter(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neonGreen),
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 6,
                            children: [
                              _buildImpactChip(
                                  "Energy 🟢", AppColors.neonGreen),
                              _buildImpactChip(
                                  "Oil ETFs 🟢", AppColors.neonGreen),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Source breakdown: 3 horizontal columns
              Text(
                "INTELLIGENCE SIGNAL BREAKDOWN",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: isDark ? AppColors.greyText : AppColors.greyTextLight,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceBreakdownCard(context, "News", "47%",
                        Icons.newspaper_rounded, AppColors.electricCyan),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSourceBreakdownCard(context, "Social", "31%",
                        Icons.forum_rounded, AppColors.warningAmber),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSourceBreakdownCard(context, "Market", "22%",
                        Icons.trending_up_rounded, AppColors.neonGreen),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Key Entities extracted
              Text(
                "EXTRACTED SIGNAL ENTITIES",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: isDark ? AppColors.greyText : AppColors.greyTextLight,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildEntityChip("Crude Oil"),
                  _buildEntityChip("Logistics Beta"),
                  _buildEntityChip("OPEC Cuts"),
                  _buildEntityChip("Freight Fuel"),
                  _buildEntityChip("Supply Hedge"),
                  _buildEntityChip("Inflation"),
                ],
              ),
              const SizedBox(height: 36),

              // Recommended action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onViewTradesTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricCyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "View Trade Decisions",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSourceBreakdownCard(
    BuildContext context,
    String source,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      borderRadius: 12,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            source,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: isDark ? AppColors.greyText : AppColors.greyTextLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntityChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.07), width: 1.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

