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

  const AnalyticsScreen({
    Key? key,
    required this.isRebalanced,
    required this.portfolioValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                                      isRebalanced ? 45 : 86,
                                      isRebalanced
                                          ? AppColors.warningAmber
                                          : AppColors.dangerRed),
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
                                    sections: isRebalanced
                                        ? [
                                            PieChartSectionData(
                                                color: AppColors.dangerRed,
                                                value: 15,
                                                title: '15%',
                                                radius: 18,
                                                titleStyle: const TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            PieChartSectionData(
                                                color: AppColors.neonGreen,
                                                value: 40,
                                                title: '40%',
                                                radius: 18,
                                                titleStyle: const TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            PieChartSectionData(
                                                color: AppColors.electricCyan,
                                                value: 45,
                                                title: '45%',
                                                radius: 18,
                                                titleStyle: const TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ]
                                        : [
                                            PieChartSectionData(
                                                color: AppColors.dangerRed,
                                                value: 35,
                                                title: '35%',
                                                radius: 18,
                                                titleStyle: const TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            PieChartSectionData(
                                                color: AppColors.neonGreen,
                                                value: 20,
                                                title: '20%',
                                                radius: 18,
                                                titleStyle: const TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            PieChartSectionData(
                                                color: AppColors.electricCyan,
                                                value: 45,
                                                title: '45%',
                                                radius: 18,
                                                titleStyle: const TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildTinyDonutLabel(
                                      "Logi", AppColors.dangerRed),
                                  _buildTinyDonutLabel(
                                      "Enrg", AppColors.neonGreen),
                                  _buildTinyDonutLabel(
                                      "Tech", AppColors.electricCyan),
                                ],
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
                          "28.4  ▲ HIGH",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.dangerRed),
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
                              spots: const [
                                FlSpot(0, 18),
                                FlSpot(1, 24),
                                FlSpot(2, 22),
                                FlSpot(3, 29),
                                FlSpot(4, 26),
                                FlSpot(5, 32),
                                FlSpot(6, 28.4),
                              ],
                              isCurved: true,
                              color: AppColors.dangerRed,
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
                      _buildStatColumn("Sharpe Ratio", "1.24", "Healthy Alpha"),
                      _buildStatColumn(
                          "Beta Coefficient", "0.87", "Low Volatility"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildStatColumn(
                          "Expected Alpha", "0.15", "Outperforming"),
                      _buildStatColumn(
                          "Max Drawdown", "-4.2%", "Protected Capital"),
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

