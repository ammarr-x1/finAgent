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
  final double sp500Change;
  final double oilWtiChange;
  final double vixChange;
  final bool isRebalanced;
  final String currentTime;
  final VoidCallback runAgent;
  final List<String> headlines;
  final List<AlertNotification> alerts;
  final Map<String, dynamic> executionData;
  final Map<String, dynamic> insight;

  const MarketDashboardScreen({
    Key? key,
    required this.portfolioValue,
    required this.sp500,
    required this.oilWti,
    required this.vix,
    required this.sp500Change,
    required this.oilWtiChange,
    required this.vixChange,
    required this.isRebalanced,
    required this.currentTime,
    required this.runAgent,
    required this.headlines,
    required this.alerts,
    required this.executionData,
    required this.insight,
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
    final legends = <Widget>[];

    activeMap.forEach((key, val) {
      final pct = (val["allocation_pct"] as num?)?.toDouble() ?? 0.0;
      final name = _formatAssetName(key);
      final color = _getAssetColor(key);
      
      sections.add(PieChartSectionData(
        color: color,
        value: pct,
        title: '${pct.toStringAsFixed(0)}%',
        radius: 30,
        titleStyle: GoogleFonts.spaceGrotesk(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));

      if (legends.isNotEmpty) {
        legends.add(const SizedBox(height: 6));
      }
      legends.add(_buildLegendRow(
        color,
        name,
        '${pct.toStringAsFixed(0)}%',
      ));
    });

    if (sections.isEmpty) {
      final defaultList = isRebalanced
          ? [
              {"asset": "FDX", "pct": 15.0, "color": AppColors.dangerRed},
              {"asset": "XOM", "pct": 40.0, "color": AppColors.neonGreen},
              {"asset": "AAPL", "pct": 30.0, "color": AppColors.electricCyan},
              {"asset": "CASH", "pct": 15.0, "color": Colors.amberAccent},
            ]
          : [
              {"asset": "FDX", "pct": 35.0, "color": AppColors.dangerRed},
              {"asset": "XOM", "pct": 20.0, "color": AppColors.neonGreen},
              {"asset": "AAPL", "pct": 30.0, "color": AppColors.electricCyan},
              {"asset": "CASH", "pct": 15.0, "color": Colors.amberAccent},
            ];

      for (var item in defaultList) {
        final pct = item["pct"] as double;
        final name = _formatAssetName(item["asset"] as String);
        final color = item["color"] as Color;

        sections.add(PieChartSectionData(
          color: color,
          value: pct,
          title: '${pct.toStringAsFixed(0)}%',
          radius: 30,
          titleStyle: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));

        if (legends.isNotEmpty) {
          legends.add(const SizedBox(height: 6));
        }
        legends.add(_buildLegendRow(
          color,
          name,
          '${pct.toStringAsFixed(0)}%',
        ));
      }
    }
    final displayHeadlines = headlines.isNotEmpty
        ? headlines
        : [
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
              NewsTicker(headlines: displayHeadlines),
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
                        "${sp500Change >= 0 ? "▲" : "▼"} ${sp500Change >= 0 ? "+" : ""}${sp500Change.toStringAsFixed(2)}%",
                        sp500Change >= 0 ? AppColors.neonGreen : AppColors.dangerRed,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMarketCard(
                        context,
                        "Oil/WTI",
                        "\$${oilWti.toStringAsFixed(2)}",
                        "${oilWtiChange >= 0 ? "▲" : "▼"} ${oilWtiChange >= 0 ? "+" : ""}${oilWtiChange.toStringAsFixed(1)}%",
                        oilWtiChange >= 0 ? AppColors.warningAmber : AppColors.dangerRed,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMarketCard(
                        context,
                        "VIX Fear Index",
                        vix.toStringAsFixed(1),
                        vixChange >= 0 ? "HIGH RISK" : "STABLE",
                        vixChange >= 0 ? AppColors.dangerRed : AppColors.neonGreen,
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
                                  sections: sections,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: legends,
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
                  if (alerts.isNotEmpty) ...[
                    for (int i = 0; i < alerts.length; i++) ...[
                      (() {
                        final a = alerts[i];
                        final prefix = a.severity == "CRITICAL" ? "🚨 " : (a.severity == "WARNING" ? "⚠️ " : "🤖 ");
                        return _buildInsightItem(
                          context,
                          "$prefix${a.title}",
                          a.body,
                          a.severity,
                          a.severityColor,
                          a.time,
                        );
                      })(),
                      if (i < alerts.length - 1) const SizedBox(height: 10),
                    ]
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          "No AI Insights generated yet. Run Agent Analysis.",
                          style: GoogleFonts.spaceGrotesk(
                            color: isDark ? AppColors.greyText : AppColors.greyTextLight,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
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
}
