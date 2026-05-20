import 'dart:async';
import 'dart:convert';
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
import '../services/api_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  double _sp500 = 7354.95;
  double _oilWti = 102.20;
  double _vix = 17.93;
  double _sp500Change = 1.20;
  double _oilWtiChange = 18.00;
  double _vixChange = 4.30;

  // AI Agent States
  bool _isRebalanced = false; // Before vs After Trade Rebalance
  bool _isTraceRunning = false;
  int _traceProgressCount = 7; // Completed initially, can be replayed
  late List<TraceStep> _traceSteps;
  late List<AlertNotification> _alerts;
  List<String> _headlines = [];
  List<dynamic> _trades = [];
  Map<String, dynamic> _activeInsight = {
    "summary": "Rising oil prices combined with negative transportation sentiment will reduce logistics profitability significantly.",
    "severity": "HIGH",
    "sector_focus": "transportation",
    "confidence": 0.91,
    "tags": ["Crude Oil", "Logistics Beta", "OPEC Cuts", "Freight Fuel", "Supply Hedge", "Inflation"],
    "affected_negative_sectors": ["Transportation", "Logistics"],
    "affected_positive_sectors": ["Energy", "Oil ETFs"],
    "sentiment_score": -0.76,
  };

  Map<String, dynamic> _executionData = {
    "trades": [],
    "portfolio_before": {
      "FDX": {"allocation_pct": 35.0, "value": 35000.0},
      "XOM": {"allocation_pct": 20.0, "value": 20000.0},
      "AAPL": {"allocation_pct": 30.0, "value": 30000.0},
      "CASH": {"allocation_pct": 15.0, "value": 15000.0}
    },
    "portfolio_after": {
      "FDX": {"allocation_pct": 15.0, "value": 15000.0},
      "XOM": {"allocation_pct": 40.0, "value": 40000.0},
      "AAPL": {"allocation_pct": 30.0, "value": 30000.0},
      "CASH": {"allocation_pct": 15.0, "value": 15000.0}
    },
    "metrics": {
      "risk_reduction": "9.0%",
      "volatility_delta": "-0.43",
      "hedging_efficiency": "97.4%"
    }
  };

  Map<String, dynamic> _riskData = {
    "risk_score": 0.86,
    "risk_label": "HIGH",
    "exposure_pct": 35.0,
    "exposure_value": 35000.0,
  };

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

    _headlines = [
      "Oil prices surge 18% amid geopolitical tensions in the Middle East",
      "Fed signals potential interest rate hike to cool inflation",
      "NASDAQ composite drops 2.3% as tech sector valuations adjust",
      "Retail sales index rises higher than forecast in Q2 review",
    ];

    _alerts = _createInitialAlerts();

    // Clock update
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateClock();
    });

    // Load actual stock / portfolio values from backend
    _loadInitialData();

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

  void _loadInitialData() async {
    try {
      final data = await ApiService.getPortfolio();
      if (data != null && data["portfolio"] != null) {
        final port = data["portfolio"];
        final holdings = port["holdings"] as Map<String, dynamic>?;
        double totalVal = 0.0;
        if (holdings != null) {
          holdings.forEach((key, value) {
            totalVal += (value["value"] ?? 0.0);
          });
        }
        if (mounted) {
          setState(() {
            if (totalVal > 0) {
              _portfolioValue = totalVal;
            }
          });
        }
      }

      // Fetch live news headlines on startup
      final liveHeadlines = await ApiService.getLiveNewsHeadlines();
      if (liveHeadlines.isNotEmpty && mounted) {
        setState(() {
          _headlines = liveHeadlines;
        });
      }

      // Fetch live market prices on startup
      final livePrices = await ApiService.getMarketPrices();
      if (livePrices != null && mounted) {
        setState(() {
          _sp500 = (livePrices["SP500"] as num?)?.toDouble() ?? _sp500;
          _oilWti = (livePrices["OIL_WTI"] as num?)?.toDouble() ?? _oilWti;
          _vix = (livePrices["VIX"] as num?)?.toDouble() ?? _vix;
          _sp500Change = (livePrices["SP500_change"] as num?)?.toDouble() ?? _sp500Change;
          _oilWtiChange = (livePrices["OIL_WTI_change"] as num?)?.toDouble() ?? _oilWtiChange;
          _vixChange = (livePrices["VIX_change"] as num?)?.toDouble() ?? _vixChange;
        });
      }
      // Fetch latest AI insight details on startup
      final liveInsight = await ApiService.getLatestInsight();
      if (liveInsight != null && mounted) {
        setState(() {
          _activeInsight = liveInsight;
        });
      }
      // Fetch latest execution details on startup
      final liveExec = await ApiService.getLatestExecution();
      if (liveExec != null && mounted) {
        setState(() {
          _executionData = liveExec;
          final liveTrades = liveExec["trades"] as List<dynamic>?;
          if (liveTrades != null && liveTrades.isNotEmpty) {
            _trades = liveTrades;
            _isRebalanced = true;
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading initial data: $e");
    }
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
  void _runAgentAnalysis() async {
    setState(() {
      _currentIndex = 1; // Direct navigate to execution trace tab
      _pageController.jumpToPage(1);
      _isTraceRunning = true;
      _traceProgressCount = 0;
      _trades = [];
      _isRebalanced = false; // Reset to BEFORE portfolio value first
      for (var step in _traceSteps) {
        step.isCompleted = false;
      }
    });

    // Start connection to WebSocket stream to receive updates
    WebSocketChannel? channel;
    try {
      channel = ApiService.connectWebSocket();
    } catch (e) {
      debugPrint("WebSocket Connection error: $e");
    }

    // Trigger the real FastAPI pipeline execution in background
    final runId = await ApiService.triggerPipeline();
    debugPrint("Triggered backend pipeline, Run ID: $runId");

    // Listen to WebSocket events
    bool receivedLiveProgress = false;
    if (channel != null) {
      channel.stream.listen((event) {
        try {
          final data = jsonDecode(event);
          if (data["type"] == "agent_progress") {
            receivedLiveProgress = true;
            final traceLog = data["trace_log"] as List<dynamic>?;
            if (traceLog != null) {
              _parseTraceLog(traceLog);
              setState(() {
                _traceProgressCount = traceLog.length;
              });
            }

            final execution = data["execution"] as Map<String, dynamic>?;
            if (execution != null && execution.isNotEmpty) {
              final liveTrades = execution["trades"] as List<dynamic>?;
              setState(() {
                _executionData = execution;
                if (liveTrades != null && liveTrades.isNotEmpty) {
                  _trades = liveTrades;
                  _isRebalanced = true;
                }
              });
            }

            final insight = data["insight"] as Map<String, dynamic>?;
            if (insight != null && insight.isNotEmpty) {
              setState(() {
                _activeInsight = insight;
              });
            }

            final risk = data["risk"] as Map<String, dynamic>?;
            if (risk != null && risk.isNotEmpty) {
              setState(() {
                _riskData = risk;
              });
            }
          }

          if (data["type"] == "pipeline_complete") {
            debugPrint("Pipeline complete received over WebSocket!");
            receivedLiveProgress = true;
            
            // Extract prices and percentage changes
            final traceLog = data["trace_log"] as List<dynamic>?;
            if (traceLog != null && traceLog.isNotEmpty) {
              final firstStep = traceLog[0]["output_contract"] as Map<String, dynamic>?;
              if (firstStep != null) {
                final prices = firstStep["market_prices"] as Map<String, dynamic>?;
                if (prices != null) {
                  setState(() {
                    _sp500 = (prices["SP500"] as num?)?.toDouble() ?? _sp500;
                    _oilWti = (prices["OIL_WTI"] as num?)?.toDouble() ?? _oilWti;
                    _vix = (prices["VIX"] as num?)?.toDouble() ?? _vix;
                    _sp500Change = (prices["SP500_change"] as num?)?.toDouble() ?? _sp500Change;
                    _oilWtiChange = (prices["OIL_WTI_change"] as num?)?.toDouble() ?? _oilWtiChange;
                    _vixChange = (prices["VIX_change"] as num?)?.toDouble() ?? _vixChange;
                  });
                }
              }
            }

            // Extract headlines
            final headlines = data["headlines"] as List<dynamic>?;
            if (headlines != null) {
              setState(() {
                _headlines = headlines.map((e) => e.toString()).toList();
              });
            }

            // Extract live trades from execution context
            final execution = data["execution"] as Map<String, dynamic>?;
            if (execution != null) {
              final liveTrades = execution["trades"] as List<dynamic>?;
              setState(() {
                _executionData = execution;
                if (liveTrades != null && liveTrades.isNotEmpty) {
                  _trades = liveTrades;
                  _isRebalanced = true;
                }
              });
            }

            // Extract live insight summary details
            final insight = data["insight"] as Map<String, dynamic>?;
            if (insight != null) {
              setState(() {
                _activeInsight = insight;
              });
            }

            final risk = data["risk"] as Map<String, dynamic>?;
            if (risk != null && risk.isNotEmpty) {
              setState(() {
                _riskData = risk;
              });
            }

            // Parse trace log into live steps
            _parseTraceLog(traceLog);

            // Parse notifications
            final notifs = data["notifications"] as List<dynamic>?;
            if (notifs != null) {
              _parseNotifications(notifs);
            }

            setState(() {
              if (traceLog != null) {
                _traceProgressCount = traceLog.length;
              }
              _isTraceRunning = false;
            });
            channel?.sink.close();
          }
        } catch (e) {
          debugPrint("Error parsing WebSocket event: $e");
        }
      }, onError: (err) {
        debugPrint("WebSocket stream error: $err");
        if (!receivedLiveProgress) {
          _animateTraceProgress(); // Fallback to visual animation anyway
        }
      }, onDone: () {
        debugPrint("WebSocket stream closed");
        if (!receivedLiveProgress) {
          _animateTraceProgress(); // Fallback if no real-time events were received
        }
      });
    } else {
      // Fallback if WebSocket is not reachable (offline/mock)
      _animateTraceProgress();
    }
  }

  void _parseTraceLog(List<dynamic>? traceLog) {
    if (traceLog == null || traceLog.isEmpty) return;

    final colors = [
      AppColors.electricCyan,
      AppColors.warningAmber,
      AppColors.warningAmber,
      AppColors.dangerRed,
      AppColors.warningAmber,
      AppColors.neonGreen,
      AppColors.neonGreen,
      AppColors.neonGreen,
    ];

    final List<TraceStep> parsedSteps = [];
    for (int i = 0; i < traceLog.length; i++) {
      final step = traceLog[i];
      final agentId = step["agent_id"] ?? "AI Agent";
      final status = step["status"] ?? "COMPLETED";
      final logs = step["reasoning_log"] as List<dynamic>? ?? [];
      final reasoning = logs.isNotEmpty 
          ? logs.join(" ") 
          : "Processed signals successfully and published output contract.";
      
      final startTimeStr = step["start_time"] ?? "";
      String timeStr = "10:00:00";
      if (startTimeStr.isNotEmpty) {
        try {
          final dt = DateTime.parse(startTimeStr).toLocal();
          timeStr = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
        } catch (_) {}
      }

      parsedSteps.add(TraceStep(
        time: timeStr,
        agentName: agentId,
        status: status,
        reasoning: reasoning,
        color: colors[i % colors.length],
        isCompleted: false,
      ));
    }

    if (parsedSteps.isNotEmpty) {
      setState(() {
        _traceSteps = parsedSteps;
      });
    }
  }

  void _parseNotifications(List<dynamic> notifs) {
    final List<AlertNotification> parsedAlerts = [];
    for (var n in notifs) {
      IconData icon = Icons.info_outline;
      final iconStr = n["icon"] ?? "";
      if (iconStr == "error_outline") {
        icon = Icons.error_outline_rounded;
      } else if (iconStr == "swap_horizontal_circle") {
        icon = Icons.swap_horizontal_circle_rounded;
      } else if (iconStr == "check_circle_outline") {
        icon = Icons.check_circle_outline_rounded;
      } else if (iconStr == "lightbulb_outline") {
        icon = Icons.lightbulb_outline_rounded;
      }

      Color severityColor = AppColors.electricCyan;
      final severity = n["severity"] ?? "INFO";
      if (severity == "CRITICAL") {
        severityColor = AppColors.dangerRed;
      } else if (severity == "WARNING") {
        severityColor = AppColors.warningAmber;
      } else if (severity == "INFO") {
        severityColor = AppColors.neonGreen;
      }

      parsedAlerts.add(AlertNotification(
        icon: icon,
        title: n["title"] ?? "Notification",
        body: n["body"] ?? "",
        time: n["timestamp"] ?? "Just Now",
        severity: severity,
        severityColor: severityColor,
        isUnread: n["is_unread"] ?? true,
      ));
    }

    if (parsedAlerts.isNotEmpty) {
      setState(() {
        _alerts = parsedAlerts;
      });
    }
  }

  void _animateTraceProgress() {
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

          // When Decision/Simulation completes, trigger portfolio rebalance state
          if (currentStep == 5) {
            _isRebalanced = true;
          }

          if (currentStep == _traceSteps.length - 1) {
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
            sp500Change: _sp500Change,
            oilWtiChange: _oilWtiChange,
            vixChange: _vixChange,
            isRebalanced: _isRebalanced,
            currentTime: _currentTime,
            runAgent: _runAgentAnalysis,
            headlines: _headlines,
            alerts: _alerts,
            executionData: _executionData,
            insight: _activeInsight,
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
            insight: _activeInsight,
          ),
          TradeSimulationScreen(
            isRebalanced: _isRebalanced,
            onToggleRebalance: _rebalanceManually,
            trades: _trades,
            executionData: _executionData,
          ),
           AnalyticsScreen(
            isRebalanced: _isRebalanced,
            portfolioValue: _portfolioValue,
            vix: _vix,
            vixChange: _vixChange,
            executionData: _executionData,
            riskData: _riskData,
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

