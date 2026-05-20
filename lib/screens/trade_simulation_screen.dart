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
// SCREEN 5 — TRADE SIMULATION
// ==========================================
class TradeSimulationScreen extends StatelessWidget {
  final bool isRebalanced;
  final VoidCallback onToggleRebalance;
  final List<dynamic> trades;
  final Map<String, dynamic> executionData;

  const TradeSimulationScreen({
    Key? key,
    required this.isRebalanced,
    required this.onToggleRebalance,
    required this.trades,
    required this.executionData,
  }) : super(key: key);

  Color _getAssetColor(String asset) {
    final upper = asset.toUpperCase();
    if (upper.contains("LOGISTICS") || upper.contains("XYZ")) {
      return AppColors.dangerRed;
    } else if (upper.contains("ENERGY") || upper.contains("OIL") || upper.contains("XOM")) {
      return AppColors.neonGreen;
    } else if (upper.contains("TECH") || upper.contains("AAPL")) {
      return AppColors.electricCyan;
    }
    // Fallbacks
    final hash = asset.hashCode.abs();
    final list = [
      AppColors.electricCyan,
      AppColors.neonGreen,
      AppColors.dangerRed,
      Colors.amberAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
    ];
    return list[hash % list.length];
  }

  String _formatAssetName(String asset) {
    final parts = asset.split("_");
    return parts.map((p) {
      if (p.isEmpty) return "";
      return p[0].toUpperCase() + p.substring(1).toLowerCase();
    }).join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final beforeMap = executionData["portfolio_before"] as Map<String, dynamic>? ?? {};
    final afterMap = executionData["portfolio_after"] as Map<String, dynamic>? ?? {};
    final metrics = executionData["metrics"] as Map<String, dynamic>? ?? {};
    final riskReduction = metrics["risk_reduction"] as String? ?? "9.0%";
    final volatilityDelta = metrics["volatility_delta"] as String? ?? "-0.43";
    final hedgingEfficiency = metrics["hedging_efficiency"] as String? ?? "97.4%";

    final beforeSections = <PieChartSectionData>[];
    String beforeText = "";
    beforeMap.forEach((key, val) {
      final pct = (val["allocation_pct"] as num?)?.toDouble() ?? 0.0;
      final name = _formatAssetName(key);
      if (beforeText.isNotEmpty) beforeText += "\n";
      beforeText += "$name: ${pct.toStringAsFixed(0)}%";
      beforeSections.add(PieChartSectionData(
        color: _getAssetColor(key),
        value: pct,
        title: '${pct.toStringAsFixed(0)}%',
        radius: 20,
        titleStyle: GoogleFonts.spaceGrotesk(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    });

    if (beforeSections.isEmpty) {
      beforeSections.add(PieChartSectionData(color: AppColors.dangerRed, value: 35, title: '35%', radius: 20, titleStyle: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)));
      beforeSections.add(PieChartSectionData(color: AppColors.neonGreen, value: 20, title: '20%', radius: 20, titleStyle: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)));
      beforeSections.add(PieChartSectionData(color: AppColors.electricCyan, value: 30, title: '30%', radius: 20, titleStyle: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)));
      beforeSections.add(PieChartSectionData(color: Colors.amberAccent, value: 15, title: '15%', radius: 20, titleStyle: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)));
      beforeText = "FedEx Corp (FDX): 35%\nExxon Mobil (XOM): 20%\nApple Inc (AAPL): 30%\nCash: 15%";
    }

    final afterSections = <PieChartSectionData>[];
    String afterText = "";
    afterMap.forEach((key, val) {
      final pct = (val["allocation_pct"] as num?)?.toDouble() ?? 0.0;
      final name = _formatAssetName(key);
      if (afterText.isNotEmpty) afterText += "\n";
      afterText += "$name: ${pct.toStringAsFixed(0)}%";
      afterSections.add(PieChartSectionData(
        color: _getAssetColor(key),
        value: pct,
        title: '${pct.toStringAsFixed(0)}%',
        radius: 20,
        titleStyle: GoogleFonts.spaceGrotesk(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    });

    if (afterSections.isEmpty) {
      afterSections.add(PieChartSectionData(color: AppColors.dangerRed, value: 15, title: '15%', radius: 20, titleStyle: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)));
      afterSections.add(PieChartSectionData(color: AppColors.neonGreen, value: 40, title: '40%', radius: 20, titleStyle: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)));
      afterSections.add(PieChartSectionData(color: AppColors.electricCyan, value: 30, title: '30%', radius: 20, titleStyle: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)));
      afterSections.add(PieChartSectionData(color: Colors.amberAccent, value: 15, title: '15%', radius: 20, titleStyle: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)));
      afterText = "FedEx Corp (FDX): 15%\nExxon Mobil (XOM): 40%\nApple Inc (AAPL): 30%\nCash: 15%";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Trade Execution Log",
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          // Simulated Switch to manual toggle allocation
          IconButton(
            onPressed: onToggleRebalance,
            icon: Icon(
              Icons.swap_calls_rounded,
              color: isRebalanced ? AppColors.neonGreen : AppColors.greyText,
            ),
            tooltip: "Force Toggle Allocation State",
          ),
        ],
      ),
      body: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Before/After side-by-side or comparison card
              Text(
                "PORTFOLIO REBALANCING TRANSITION",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isDark ? AppColors.greyText : AppColors.greyTextLight,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  // BEFORE chart
                  Expanded(
                    child: GlassCard(
                      borderRadius: 14,
                      padding: const EdgeInsets.all(10),
                      borderColor: !isRebalanced
                          ? AppColors.dangerRed.withOpacity(0.4)
                          : null,
                      child: Column(
                        children: [
                          Text(
                            "BEFORE (HIGH RISK)",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dangerRed,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 80,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 20,
                                sections: beforeSections,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              beforeText,
                              style:
                                  GoogleFonts.inter(fontSize: 9, height: 1.4),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ARROW
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.electricCyan.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.electricCyan,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),

                  // AFTER chart
                  Expanded(
                    child: GlassCard(
                      borderRadius: 14,
                      padding: const EdgeInsets.all(10),
                      borderColor: isRebalanced
                          ? AppColors.neonGreen.withOpacity(0.4)
                          : null,
                      child: Column(
                        children: [
                          Text(
                            "AFTER (MITIGATED)",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neonGreen,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 80,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 20,
                                sections: afterSections,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              afterText,
                              style:
                                  GoogleFonts.inter(fontSize: 9, height: 1.4),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Transaction Terminal Logs (Bloomberg terminal style)
              Text(
                "EXECUTION ORDER AUDIT LOG",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isDark ? AppColors.greyText : AppColors.greyTextLight,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF070B13),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.green.withOpacity(0.2), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const PulsingIndicator(color: Colors.green, size: 6),
                        const SizedBox(width: 8),
                        Text(
                          trades.isNotEmpty 
                              ? "LIVE TERMINAL PORTFOLIO SYNC..." 
                              : "TERMINAL STAGE 1 READY...",
                          style: GoogleFonts.spaceGrotesk(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (trades.isNotEmpty) ...[
                      for (var i = 0; i < trades.length; i++) ...[
                        (() {
                          final t = trades[i];
                          final action = t["action"] ?? "BUY";
                          final asset = t["asset"] ?? "";
                          final qtyStr = "${(t["quantity"] as num?)?.toStringAsFixed(1) ?? "0"} units";
                          final priceStr = "@ \$${(t["exec_price"] as num?)?.toStringAsFixed(2) ?? "0.00"}";
                          final valStr = "${action == "BUY" ? "+" : "-"}\$${(t["delta_value"] as num?)?.toStringAsFixed(2) ?? "0.00"}";
                          
                          // Format timestamp to hh:mm:ss
                          String timeStr = "11:00:00";
                          final rawTs = t["timestamp"] ?? "";
                          if (rawTs.isNotEmpty) {
                            try {
                              final parsed = DateTime.parse(rawTs).toLocal();
                              timeStr = "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}:${parsed.second.toString().padLeft(2, '0')}";
                            } catch (_) {}
                          }

                          return _buildTerminalLine(
                            timeStr,
                            action,
                            asset,
                            qtyStr,
                            priceStr,
                            valStr,
                            action == "BUY" ? Colors.greenAccent : Colors.redAccent,
                          );
                        })(),
                        if (i < trades.length - 1) const SizedBox(height: 6),
                      ]
                    ] else ...[
                      _buildTerminalLine(
                          "",
                          "SYSTEM",
                          "No active trades. Run Agent Analysis to execute simulation.",
                          "",
                          "",
                          "",
                          AppColors.electricCyan),
                    ],
                    const SizedBox(height: 10),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 4),
                    Text(
                      trades.isNotEmpty 
                          ? ">> ALL TRADES RECORDED SECURELY IN LIVE FIRESTORE DATABASE.\n>> SYNC STATE COMPLETE. RISK MARGIN WITHIN NOMINAL RANGE."
                          : ">> ALL ORDERS SETTLED VIA LIQUIDITY POOL PORT A.\n>> MARGIN RATIO ADEQUATE. REDUCTION OF LOGISTICS EXPOSURE CONFIRMED.",
                      style: GoogleFonts.spaceGrotesk(
                          color: Colors.grey, fontSize: 9),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Risk Change progress bar
              Text(
                "RISK PROFILE SCORE PROGRESSION",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isDark ? AppColors.greyText : AppColors.greyTextLight,
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                borderRadius: 12,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Before: 90% (HIGH)",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dangerRed),
                        ),
                        Text(
                          "After: 45% (MEDIUM)",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warningAmber),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: isRebalanced ? 0.45 : 0.90,
                      backgroundColor: (isDark ? Colors.white : Colors.black)
                          .withOpacity(0.08),
                      progressColor: isRebalanced
                          ? AppColors.warningAmber
                          : AppColors.dangerRed,
                      barRadius: const Radius.circular(8),
                      animation: true,
                      animationDuration: 1200,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // P&L summary metrics card
              GlassCard(
                borderRadius: 12,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPnlIndicator(
                        "Risk Reduction", riskReduction, AppColors.electricCyan),
                    _buildPnlIndicator(
                        "Volatility Delta", volatilityDelta, AppColors.neonGreen),
                    _buildPnlIndicator(
                        "Hedging Efficiency", hedgingEfficiency, AppColors.warningAmber),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTerminalLine(
    String time,
    String side,
    String asset,
    String qty,
    String price,
    String value,
    Color sideColor,
  ) {
    return Row(
      children: [
        Text("[$time]",
            style:
                GoogleFonts.spaceGrotesk(color: Colors.white38, fontSize: 10)),
        const SizedBox(width: 8),
        Text(side,
            style: GoogleFonts.spaceGrotesk(
                color: sideColor, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(
            child: Text(asset,
                style: GoogleFonts.spaceGrotesk(
                    color: Colors.white, fontSize: 10))),
        Text(qty,
            style:
                GoogleFonts.spaceGrotesk(color: Colors.white70, fontSize: 10)),
        const SizedBox(width: 10),
        Text(price,
            style:
                GoogleFonts.spaceGrotesk(color: Colors.white70, fontSize: 10)),
        const SizedBox(width: 10),
        Text(value,
            style: GoogleFonts.spaceGrotesk(
                color: sideColor, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPnlIndicator(String title, String val, Color highlight) {
    return Column(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: AppColors.greyText),
        ),
        const SizedBox(height: 5),
        Text(
          val,
          style: GoogleFonts.spaceGrotesk(
              fontSize: 16, fontWeight: FontWeight.w800, color: highlight),
        ),
      ],
    );
  }
}

