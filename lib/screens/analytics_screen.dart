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
// SCREEN 6 — ANALYTICS
// ==========================================
class AnalyticsScreen extends StatelessWidget {
  final bool isRebalanced;
  final double portfolioValue;
  final double vix;
  final double vixChange;
  final Map<String, dynamic> executionData;
  final Map<String, dynamic> riskData;

  const AnalyticsScreen({
    Key? key,
    required this.isRebalanced,
    required this.portfolioValue,
    required this.vix,
    required this.vixChange,
    required this.executionData,
    required this.riskData,
  }) : super(key: key);

  Color _getAssetColor(String asset) {
    final upper = asset.toUpperCase();
    if (upper.contains("LOGISTICS") || upper.contains("XYZ") || upper.contains("FDX")) {
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
    if (asset == "VTI") return "Total Stock Market (VTI)";
    if (asset == "AAPL") return "Apple Inc (AAPL)";
    if (asset == "FDX") return "FedEx Corp (FDX)";
    if (asset == "XOM") return "Exxon Mobil (XOM)";
    if (asset == "CASH") return "Cash";
    final parts = asset.split("_");
    return parts.map((p) {
      if (p.isEmpty) return "";
      return p[0].toUpperCase() + p.substring(1).toLowerCase();
    }).join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeMap = (isRebalanced
        ? (executionData["portfolio_after"] as Map<String, dynamic>? ?? {})
        : (executionData["portfolio_before"] as Map<String, dynamic>? ?? {}));

    final sections = <PieChartSectionData>[];
    final labels = <Widget>[];

    activeMap.forEach((key, val) {
      final pct = (val["allocation_pct"] as num?)?.toDouble() ?? 0.0;
      final color = _getAssetColor(key);

      sections.add(PieChartSectionData(
        color: color,
        value: pct,
        title: '${pct.toStringAsFixed(0)}%',
        radius: 18,
        titleStyle: const TextStyle(
          fontSize: 7,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));

      String shortLabel = key;
      if (key == "FDX") shortLabel = "Logi";
      else if (key == "XOM") shortLabel = "Enrg";
      else if (key == "AAPL") shortLabel = "Tech";
      else if (key == "CASH") shortLabel = "Cash";

      labels.add(_buildTinyDonutLabel(shortLabel, color));
    });

    if (sections.isEmpty) {
      final defaultList = isRebalanced
          ? [
              {"asset": "Logi", "pct": 15.0, "color": AppColors.dangerRed},
              {"asset": "Enrg", "pct": 40.0, "color": AppColors.neonGreen},
              {"asset": "Tech", "pct": 30.0, "color": AppColors.electricCyan},
              {"asset": "Cash", "pct": 15.0, "color": Colors.amberAccent},
            ]
          : [
              {"asset": "Logi", "pct": 35.0, "color": AppColors.dangerRed},
              {"asset": "Enrg", "pct": 20.0, "color": AppColors.neonGreen},
              {"asset": "Tech", "pct": 30.0, "color": AppColors.electricCyan},
              {"asset": "Cash", "pct": 15.0, "color": Colors.amberAccent},
            ];

      for (var item in defaultList) {
        final pct = item["pct"] as double;
        final asset = item["asset"] as String;
        final color = item["color"] as Color;

        sections.add(PieChartSectionData(
          color: color,
          value: pct,
          title: '${pct.toStringAsFixed(0)}%',
          radius: 18,
          titleStyle: const TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));

        labels.add(_buildTinyDonutLabel(asset, color));
      }
    }

    final rawScore = riskData["risk_score"] as num? ?? 0.86;
    final currentRiskScorePct = (rawScore <= 1.0 ? rawScore * 100 : rawScore).toDouble();

    double activeRiskScore = currentRiskScorePct;
    if (isRebalanced) {
      final reductionStr = executionData["metrics"]?["risk_reduction"] as String? ?? "9.0%";
      final reduction = double.tryParse(reductionStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 9.0;
      activeRiskScore = (currentRiskScorePct - reduction).clamp(0.0, 100.0);
    }

    final activeRiskColor = activeRiskScore > 75.0
        ? AppColors.dangerRed
        : (activeRiskScore > 40.0 ? AppColors.warningAmber : AppColors.neonGreen);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Portfolio Analytics",
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
              // 7 Day Line Chart Title
              Text(
                "PORTFOLIO PERFORMANCE (7 DAYS)",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isDark ? AppColors.greyText : AppColors.greyTextLight,
                ),
              ),
              const SizedBox(height: 12),

              // Animated Line Chart Container
              GlassCard(
                borderRadius: 14,
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, right: 20, left: 10),
                child: SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 45,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '\$${(value / 1000).toStringAsFixed(0)}k',
                                style: GoogleFonts.spaceGrotesk(
                                  color: isDark
                                      ? AppColors.greyText
                                      : AppColors.greyTextLight,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ];
                              if (value.toInt() >= 0 &&
                                  value.toInt() < days.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    days[value.toInt()],
                                    style: GoogleFonts.spaceGrotesk(
                                      color: isDark
                                          ? AppColors.greyText
                                          : AppColors.greyTextLight,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 6,
                      minY: 118000,
                      maxY: 126000,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 121000),
                            FlSpot(1, 120500),
                            FlSpot(2, 121800),
                            FlSpot(3, 121200),
                            FlSpot(4, 122900),
                            FlSpot(5, 123800),
                            FlSpot(6, portfolioValue),
                          ],
                          isCurved: true,
                          color: AppColors.electricCyan,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              if (index == 6) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: AppColors.electricCyan,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              }
                              return FlDotCirclePainter(
                                  radius: 0, color: Colors.transparent);
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.electricCyan.withOpacity(0.25),
                                AppColors.electricCyan.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Bar Chart: Risk Score Trend & Sector Side-By-Side Donuts
              Row(
                children: [
                  // Risk Score Bar Chart
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RISK SCORE TREND",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greyText,
                              letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 10),
                        GlassCard(
                          borderRadius: 14,
                          padding: const EdgeInsets.only(
                              top: 15, right: 10, left: 5, bottom: 5),
                          child: SizedBox(
                            height: 120,
                            child: BarChart(
                              BarChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: GoogleFonts.spaceGrotesk(
                                              fontSize: 8,
                                              color: AppColors.greyText),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        const tags = [
                                          'D1',
                                          'D2',
                                          'D3',
                                          'D4',
                                          'D5',
                                          'D6',
                                          'D7'
                                        ];
                                        if (value.toInt() >= 0 &&
                                            value.toInt() < tags.length) {
                                          return Text(
                                            tags[value.toInt()],
                                            style: GoogleFonts.spaceGrotesk(
                                                fontSize: 8,
                                                color: AppColors.greyText),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                barGroups: [
                                  _buildBarGroup(0, 85, AppColors.dangerRed),
                                  _buildBarGroup(1, 88, AppColors.dangerRed),
                                  _buildBarGroup(2, 90, AppColors.dangerRed),
                                  _buildBarGroup(3, 92, AppColors.dangerRed),
                                  _buildBarGroup(4, 91, AppColors.dangerRed),
                                  _buildBarGroup(5, 87, AppColors.dangerRed),
                                  _buildBarGroup(
                                      6,
                                      activeRiskScore,
                                      activeRiskColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Donut Sector Allocation
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SECTOR EXPOSURE",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greyText,
                              letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 10),
                        GlassCard(
                          borderRadius: 14,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 85,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 22,
                                    sections: sections,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: labels,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Volatility sparkline index card
              Text(
                "VOLATILITY INDEX INDEX SPARKLINE",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isDark ? AppColors.greyText : AppColors.greyTextLight,
                ),
              ),
              const SizedBox(height: 10),
              GlassCard(
                borderRadius: 12,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "VOLATILITY INDEX (VIX)",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greyText),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${vix.toStringAsFixed(1)}  ${vixChange >= 0 ? "▲" : "▼"} ${vix > 25.0 ? "HIGH" : (vix > 18.0 ? "MED" : "LOW")}",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: vix > 25.0
                                  ? AppColors.dangerRed
                                  : (vix > 18.0 ? AppColors.warningAmber : AppColors.neonGreen)),
                        ),
                      ],
                    ),
                    // Sparkline drawing
                    SizedBox(
                      width: 120,
                      height: 35,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                const FlSpot(0, 18),
                                const FlSpot(1, 24),
                                const FlSpot(2, 22),
                                const FlSpot(3, 29),
                                const FlSpot(4, 26),
                                const FlSpot(5, 32),
                                FlSpot(6, vix),
                              ],
                              isCurved: true,
                              color: vix > 25.0
                                  ? AppColors.dangerRed
                                  : (vix > 18.0 ? AppColors.warningAmber : AppColors.neonGreen),
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Financial stats row
              Table(
                children: [
                  TableRow(
                    children: [
                      _buildStatColumn("Sharpe Ratio", isRebalanced ? "1.85" : "1.24", isRebalanced ? "Optimized Alpha" : "Healthy Alpha"),
                      _buildStatColumn(
                          "Beta Coefficient", isRebalanced ? "0.48" : "0.87", isRebalanced ? "Hedged / Low Vol" : "Low Volatility"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildStatColumn(
                          "Expected Alpha", isRebalanced ? "0.23" : "0.15", isRebalanced ? "High Outperformance" : "Outperforming"),
                      _buildStatColumn(
                          "Max Drawdown", isRebalanced ? "-1.8%" : "-4.2%", isRebalanced ? "Capital Shielded" : "Protected Capital"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 8,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildTinyDonutLabel(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String header, String val, String sub) {
    return GlassCard(
      borderRadius: 12,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: AppColors.greyText),
          ),
          const SizedBox(height: 6),
          Text(
            val,
            style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.electricCyan),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.inter(
                fontSize: 8, color: AppColors.greyText.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}

