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
import 'market_dashboard_screen.dart';
import 'live_agent_trace_screen.dart';
import 'insight_details_screen.dart';
import 'trade_simulation_screen.dart';
import 'analytics_screen.dart';
import 'alerts_screen.dart';

// ==========================================
// MAIN APP SHELL WITH STATE MANAGEMENT
// ==========================================
class AppShell extends StatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;

  // Real-time fluctuating ticker states
  late Timer _marketTimer;
  double _portfolioValue = 124500.00;
  double _sp500 = 5234.15;
  double _oilWti = 94.50;
  double _vix = 28.40;

  // AI Agent States
  bool _isRebalanced = false; // Before vs After Trade Rebalance
  bool _isTraceRunning = false;
  int _traceProgressCount = 7; // Completed initially, can be replayed
  late List<TraceStep> _traceSteps;
  late List<AlertNotification> _alerts;

  // Clock state
  String _currentTime = "";
  late Timer _clockTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _traceSteps = _createInitialSteps();
    for (var step in _traceSteps) {
      step.isCompleted = true; // Initially complete
    }

    _alerts = _createInitialAlerts();

    // Clock update
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateClock();
    });

    // Market ticker fluctuation simulations
    _marketTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          // Subtle fluctuations (Robinhood / Bloomberg Terminal vibe)
          _portfolioValue +=
              (double.parse((timer.tick % 3 == 0 ? 1 : -1).toString()) *
                  (12.4 + (timer.tick % 5)));
          _sp500 +=
              (double.parse((timer.tick % 2 == 0 ? 0.3 : -0.2).toString()) *
                  0.85);
          _oilWti +=
              (double.parse((timer.tick % 4 == 0 ? 0.15 : -0.1).toString()) *
                  0.2);
          _vix +=
              (double.parse((timer.tick % 5 == 0 ? -0.12 : 0.08).toString()));
        });
      }
    });
  }

  void _updateClock() {
    final now = DateTime.now();
    final padMin = now.minute.toString().padLeft(2, '0');
    final padSec = now.second.toString().padLeft(2, '0');
    final padHr = now.hour.toString().padLeft(2, '0');
    if (mounted) {
      setState(() {
        _currentTime = "$padHr:$padMin:$padSec UTC";
      });
    }
  }

  List<TraceStep> _createInitialSteps() {
    return [
      TraceStep(
        time: "10:00:01",
        agentName: "Input Intelligence Agent",
        status: "COMPLETED",
        reasoning:
            "Processed 47 news headlines, 12 financial RSS items, and 8 active social signals from terminal integrations.",
        color: AppColors.electricCyan,
      ),
      TraceStep(
        time: "10:00:03",
        agentName: "News Intelligence Agent",
        status: "COMPLETED",
        reasoning:
            "Identified severe energy cost increases and localized transportation sector impacts following OPEC production cuts.",
        color: AppColors.warningAmber,
      ),
      TraceStep(
        time: "10:00:05",
        agentName: "Sentiment Analysis Agent",
        status: "COMPLETED",
        reasoning:
            "Calculated global logistics sentiment at NEGATIVE (-0.76). Discovered deep bearish signals in air/rail freight sentiment indices.",
        color: AppColors.warningAmber,
      ),
      TraceStep(
        time: "10:00:07",
        agentName: "Portfolio Risk Agent",
        status: "COMPLETED",
        reasoning:
            "Detected risk exposure elevated to HIGH. Identified 'XYZ Logistics' (35% allocation) as highly vulnerable with \$1,800 projected downside.",
        color: AppColors.dangerRed,
      ),
      TraceStep(
        time: "10:00:09",
        agentName: "Decision Agent",
        status: "COMPLETED",
        reasoning:
            "Action Approved: Instantly SELL XYZ Logistics (reducing exposure from 35% to 15%) and BUY Energy Fund (increasing from 20% to 40%) as a direct margin hedge.",
        color: AppColors.warningAmber,
      ),
      TraceStep(
        time: "10:00:11",
        agentName: "Trade Simulation Agent",
        status: "COMPLETED",
        reasoning:
            "Dispatched 2 automated orders successfully. Traded 50 units XYZ SELL, and 30 units BUY Energy Fund at best execution market rates.",
        color: AppColors.neonGreen,
      ),
      TraceStep(
        time: "10:00:13",
        agentName: "Notification Agent",
        status: "COMPLETED",
        reasoning:
            "Completed core agent flow. Portfolio rebalanced. Risk successfully mitigated: HIGH → MEDIUM. Dispatching user notifications.",
        color: AppColors.neonGreen,
      ),
    ];
  }

  List<AlertNotification> _createInitialAlerts() {
    return [
      AlertNotification(
        icon: Icons.error_outline_rounded,
        title: "Portfolio risk elevated to HIGH",
        body:
            "High sector vulnerability detected in XYZ Logistics due to macro headwinds. Immediate mitigating trade recommended.",
        time: "15m ago",
        severity: "CRITICAL",
        severityColor: AppColors.dangerRed,
        isUnread: true,
      ),
      AlertNotification(
        icon: Icons.trending_up_rounded,
        title: "Oil prices exceeded 15% threshold",
        body:
            "Brent crude futures crossed \$94. OPEC policy updates triggered automated sector exposure audits.",
        time: "32m ago",
        severity: "WARNING",
        severityColor: AppColors.warningAmber,
        isUnread: true,
      ),
      AlertNotification(
        icon: Icons.check_circle_outline_rounded,
        title: "Agent workflow completed",
        body:
            "FinAgent analyzed the market impact, ran simulation strategies, and successfully executed 2 rebalancing trades.",
        time: "1h ago",
        severity: "INFO",
        severityColor: AppColors.neonGreen,
        isUnread: false,
      ),
      AlertNotification(
        icon: Icons.security_rounded,
        title: "Risk level mitigated: HIGH → MEDIUM",
        body:
            "Rebalancing completed successfully: XYZ Logistics sold down; Energy Hedging index acquired. Risk mitigated.",
        time: "1h ago",
        severity: "INFO",
        severityColor: AppColors.neonGreen,
        isUnread: false,
      ),
    ];
  }

  // Action to Run / Replay autonomous AI execution sequence
  void _runAgentAnalysis() {
    setState(() {
      _currentIndex = 1; // Direct navigate to execution trace tab
      _pageController.jumpToPage(1);
      _isTraceRunning = true;
      _traceProgressCount = 0;
      _isRebalanced = false; // Reset to BEFORE portfolio value first
      for (var step in _traceSteps) {
        step.isCompleted = false;
      }
    });

    int currentStep = 0;
    Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (currentStep < _traceSteps.length) {
        setState(() {
          _traceSteps[currentStep].isCompleted = true;
          _traceProgressCount = currentStep + 1;

          // When Trade Simulation agent completes, rebalance portfolio!
          if (currentStep == 5) {
            _isRebalanced = true;
          }

          // When Notification agent completes, mark system alerts as completed
          if (currentStep == 6) {
            // Prepend a fresh info notification to show real activity
            _alerts.insert(
              0,
              AlertNotification(
                icon: Icons.bolt_rounded,
                title: "Live Analysis Complete",
                body:
                    "Autonomous Trace re-run completes. Risk score successfully validated and hedge confirmed.",
                time: "Just Now",
                severity: "INFO",
                severityColor: AppColors.neonGreen,
                isUnread: true,
              ),
            );
            _isTraceRunning = false;
            timer.cancel();
          }
        });
        currentStep++;
      } else {
        timer.cancel();
      }
    });
  }

  void _rebalanceManually() {
    setState(() {
      _isRebalanced = !_isRebalanced;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _marketTimer.cancel();
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(), // tab navigation lock
        children: [
          MarketDashboardScreen(
            portfolioValue: _portfolioValue,
            sp500: _sp500,
            oilWti: _oilWti,
            vix: _vix,
            isRebalanced: _isRebalanced,
            currentTime: _currentTime,
            runAgent: _runAgentAnalysis,
          ),
          LiveAgentTraceScreen(
            steps: _traceSteps,
            isTraceRunning: _isTraceRunning,
            progressCount: _traceProgressCount,
            replay: _runAgentAnalysis,
          ),
          InsightDetailsScreen(
            onViewTradesTap: () {
              setState(() {
                _currentIndex = 3;
                _pageController.jumpToPage(3);
              });
            },
          ),
          TradeSimulationScreen(
            isRebalanced: _isRebalanced,
            onToggleRebalance: _rebalanceManually,
          ),
          AnalyticsScreen(
            isRebalanced: _isRebalanced,
            portfolioValue: _portfolioValue,
          ),
          AlertsScreen(
            alerts: _alerts,
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _runAgentAnalysis,
              backgroundColor: AppColors.electricCyan,
              foregroundColor: Colors.black,
              elevation: 8,
              icon: const Icon(Icons.rocket_launch_rounded, size: 20),
              label: Text(
                "Run Agent Analysis",
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            )
          : null,
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          border: Border(
            top: BorderSide(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.08),
              width: 1,
            ),
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: AppColors.electricCyan.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                  0, Icons.dashboard_customize_rounded, "Dashboard"),
              _buildBottomNavItem(1, Icons.psychology_rounded, "Trace"),
              _buildBottomNavItem(
                  2, Icons.lightbulb_outline_rounded, "Insights"),
              _buildBottomNavItem(
                  3, Icons.swap_horizontal_circle_rounded, "Trades"),
              _buildBottomNavItem(4, Icons.analytics_rounded, "Analytics"),
              _buildBottomNavItem(
                  5, Icons.notifications_active_rounded, "Alerts",
                  showBadge: _alerts.any((a) => a.isUnread)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label,
      {bool showBadge = false}) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = AppColors.electricCyan;
    final inactiveColor = isDark ? AppColors.greyText : AppColors.greyTextLight;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 24,
                  shadows: isSelected
                      ? [
                          Shadow(
                            color: activeColor.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                if (showBadge)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.dangerRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? (isDark ? Colors.white : AppColors.lightText)
                    : inactiveColor,
              ),
            ),
            const SizedBox(height: 4),
            // Neon underline glow
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2.5,
              width: isSelected ? 22 : 0,
              decoration: BoxDecoration(
                color: AppColors.electricCyan,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricCyan.withOpacity(0.8),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

