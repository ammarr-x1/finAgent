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
// SCREEN 3 — LIVE AGENT TRACE
// ==========================================
class LiveAgentTraceScreen extends StatefulWidget {
  final List<TraceStep> steps;
  final bool isTraceRunning;
  final int progressCount;
  final VoidCallback replay;

  const LiveAgentTraceScreen({
    Key? key,
    required this.steps,
    required this.isTraceRunning,
    required this.progressCount,
    required this.replay,
  }) : super(key: key);

  @override
  State<LiveAgentTraceScreen> createState() => _LiveAgentTraceScreenState();
}

class _LiveAgentTraceScreenState extends State<LiveAgentTraceScreen> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Agent Execution Trace",
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
              // Workflow Status Badge at the Top
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "AUTONOMOUS WORKFLOW",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color:
                          isDark ? AppColors.greyText : AppColors.greyTextLight,
                    ),
                  ),
                  // Green Complete Check Chip
                  widget.isTraceRunning
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.warningAmber.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.warningAmber.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const PulsingIndicator(
                                  color: AppColors.warningAmber, size: 8),
                              const SizedBox(width: 6),
                              Text(
                                "EXECUTING AGENTS...",
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warningAmber,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.neonGreen.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.neonGreen.withOpacity(0.3)),
                          ),
                          child: Text(
                            "WORKFLOW COMPLETE ✓",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neonGreen,
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 20),

              // Vertically Staggered Timeline
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.steps.length,
                itemBuilder: (context, index) {
                  final step = widget.steps[index];
                  final isStepVisible = index < widget.progressCount;

                  if (!isStepVisible) {
                    return const SizedBox();
                  }

                  return FadeInLeft(
                    duration: const Duration(milliseconds: 300),
                    child: _buildTimelineRow(context, index, step),
                  );
                },
              ),
              const SizedBox(height: 30),

              // Replay Trace Button at the bottom
              if (!widget.isTraceRunning)
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: widget.replay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkSurface,
                        foregroundColor: AppColors.electricCyan,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: AppColors.electricCyan.withOpacity(0.4),
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(
                        "Replay Autonomous Trace",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineRow(BuildContext context, int index, TraceStep step) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpanded = _expandedIndex == index;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Connecting line and dot structure
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBg : AppColors.lightBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: step.color,
                  width: 3.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: step.color.withOpacity(0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            if (index < widget.steps.length - 1)
              Container(
                width: 2,
                height: isExpanded ? 110 : 75,
                color: step.color.withOpacity(0.35),
              ),
          ],
        ),
        const SizedBox(width: 14),

        // Timeline Step Content Glass Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? null : index;
                });
              },
              child: GlassCard(
                borderRadius: 12,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            step.agentName,
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color:
                                  isDark ? Colors.white : AppColors.lightText,
                            ),
                          ),
                        ),
                        Text(
                          "[${step.time}]",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.greyText.withOpacity(0.6)
                                : AppColors.greyTextLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Status and Expand hint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: step.color,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              step.status,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: step.color,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          isExpanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          size: 16,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ],
                    ),

                    // Expandable reasoning details
                    AnimatedCrossFade(
                      firstChild: const SizedBox(height: 0),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(color: Colors.white10),
                            const SizedBox(height: 4),
                            Text(
                              step.reasoning,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                height: 1.4,
                                color: isDark
                                    ? AppColors.greyText
                                    : AppColors.greyTextLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

