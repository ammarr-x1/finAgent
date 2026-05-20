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
import '../widgets/typewriter_text.dart';
import '../widgets/news_ticker.dart';
import '../widgets/risk_badge.dart';
// ==========================================
// SCREEN 2 — MARKET DASHBOARD
// ==========================================
class MarketDashboardScreen extends StatelessWidget {
  final double portfolioValue;
  final double sp500;
  final double oilWti;
  final double vix;
  final bool isRebalanced;
  final String currentTime;
  final VoidCallback runAgent;

  const MarketDashboardScreen({
    Key? key,
    required this.portfolioValue,
    required this.sp500,
    required this.oilWti,
    required this.vix,
    required this.isRebalanced,
    required this.currentTime,
    required this.runAgent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headlines = [
      "Oil prices surge 18% amid geopolitical tensions in the Middle East",
      "Fed signals potential interest rate hike to cool inflation",
      "NASDAQ composite drops 2.3% as tech sector valuations adjust",
      "Retail sales index rises higher than forecast in Q2 review",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.electricCyan.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.hub_rounded,
                  color: AppColors.electricCyan, size: 22),
            ),
            const SizedBox(width: 10),
            Text(
              "FinAgent",
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: isDark ? Colors.white : AppColors.lightText,
              ),
            ),
          ],
        ),
        actions: [
          // Live Clock
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              currentTime,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.electricCyan
                    : AppColors.lightText.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Theme Toggle Button
          IconButton(
            onPressed: () {
              themeModeNotifier.value =
                  themeModeNotifier.value == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
            },
            icon: ValueListenableBuilder<ThemeMode>(
              valueListenable: themeModeNotifier,
              builder: (context, theme, _) {
                return Icon(
                  theme == ThemeMode.dark
                      ? Icons.wb_sunny_rounded
                      : Icons.nights_stay_rounded,
                  color: theme == ThemeMode.dark
                      ? AppColors.warningAmber
                      : AppColors.lightText,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breaking news ticker scroller
              NewsTicker(headlines: headlines),
              const SizedBox(height: 16),

              // 3 Market Indicator cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMarketCard(
                        context,
                        "S&P 500",
                        sp500.toStringAsFixed(1),
                        "▲ +1.2%",
                        AppColors.neonGreen,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMarketCard(
                        context,
                        "Oil/WTI",
                        "\$${oilWti.toStringAsFixed(2)}",
                        "▲ +18.0%",
                        AppColors.warningAmber,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMarketCard(
                        context,
                        "VIX Fear Index",
                        vix.toStringAsFixed(1),
                        "HIGH RISK",
                        AppColors.dangerRed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Portfolio Overview card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PORTFOLIO VALUE",
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.greyText
                                      : AppColors.greyTextLight,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "\$${portfolioValue.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.lightText,
                                ),
                              ),
                            ],
                          ),
                          // Risk badge changes from HIGH (red) to MEDIUM (amber) depending on rebalance state
                          isRebalanced
                              ? const RiskBadge(
                                  label: "MEDIUM RISK",
                                  color: AppColors.warningAmber)
                              : const RiskBadge(
                                  label: "HIGH RISK",
                                  color: AppColors.dangerRed),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 10),
                      Text(
                        "ASSET EXPOSURE ALLOCATION",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.greyTextLight,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Mini Pie Chart Exposure
                      SizedBox(
                        height: 120,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 3,
                                  centerSpaceRadius: 28,
                                  sections: isRebalanced
                                      ? [
                                          PieChartSectionData(
                                            color: AppColors.dangerRed,
                                            value: 15,
                                            title: '15%',
                                            radius: 30,
                                            titleStyle:
                                                GoogleFonts.spaceGrotesk(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            color: AppColors.neonGreen,
                                            value: 40,
                                            title: '40%',
                                            radius: 30,
                                            titleStyle:
                                                GoogleFonts.spaceGrotesk(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            color: AppColors.electricCyan,
                                            value: 45,
                                            title: '45%',
                                            radius: 30,
                                            titleStyle:
                                                GoogleFonts.spaceGrotesk(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ]
                                      : [
                                          PieChartSectionData(
                                            color: AppColors.dangerRed,
                                            value: 35,
                                            title: '35%',
                                            radius: 30,
                                            titleStyle:
                                                GoogleFonts.spaceGrotesk(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            color: AppColors.neonGreen,
                                            value: 20,
                                            title: '20%',
                                            radius: 30,
                                            titleStyle:
                                                GoogleFonts.spaceGrotesk(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            color: AppColors.electricCyan,
                                            value: 45,
                                            title: '45%',
                                            radius: 30,
                                            titleStyle:
                                                GoogleFonts.spaceGrotesk(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLegendRow(
                                    AppColors.dangerRed,
                                    "XYZ Logistics",
                                    isRebalanced ? "15%" : "35%",
                                  ),
                                  const SizedBox(height: 6),
                                  _buildLegendRow(
                                    AppColors.neonGreen,
                                    "Energy Hedging",
                                    isRebalanced ? "40%" : "20%",
                                  ),
                                  const SizedBox(height: 6),
                                  _buildLegendRow(
                                    AppColors.electricCyan,
                                    "Tech Index ETF",
                                    "45%",
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // AI Insights Feed Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "AI INSIGHTS FEED",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: isDark ? Colors.white : AppColors.lightText,
                      ),
                    ),
                    Text(
                      "LIVE UPDATES",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        color: AppColors.neonGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Scrollable Insight Cards
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildInsightItem(
                    context,
                    "🤖 Transportation sector at elevated risk",
                    "Surging oil prices are directly damaging transport logistics operations. Exposure mitigations initialized automatically.",
                    "HIGH",
                    AppColors.dangerRed,
                    "3m ago",
                  ),
                  const SizedBox(height: 10),
                  _buildInsightItem(
                    context,
                    "⚡ Energy assets outperformance predicted",
                    "OPEC output constraints will keep crude values elevated, triggering strong momentum gains in oil ETFs.",
                    "MED",
                    AppColors.warningAmber,
                    "15m ago",
                  ),
                  const SizedBox(height: 10),
                  _buildInsightItem(
                    context,
                    "📉 Technology valuations hold support",
                    "Tech index ETF maintains solid levels despite volatility, representing robust portfolio stability.",
                    "LOW",
                    AppColors.electricCyan,
                    "44m ago",
                  ),
                ],
              ),
              const SizedBox(height: 100), // padding bottom for fab spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarketCard(
    BuildContext context,
    String title,
    String value,
    String percent,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      borderRadius: 12,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.greyText : AppColors.greyTextLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                percent,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem(
    BuildContext context,
    String title,
    String desc,
    String severity,
    Color severityColor,
    String timestamp,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.lightText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  severity,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: severityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? AppColors.greyText : AppColors.greyTextLight,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Source: FinAgent Intelligence Engine",
                style: GoogleFonts.inter(
                  fontSize: 9,
                  color: isDark
                      ? AppColors.greyText.withOpacity(0.5)
                      : AppColors.greyTextLight.withOpacity(0.7),
                ),
              ),
              Text(
                timestamp,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.greyText.withOpacity(0.8)
                      : AppColors.greyTextLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
}
