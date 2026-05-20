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
// SCREEN 7 — NOTIFICATIONS (AI ALERTS)
// ==========================================
class AlertsScreen extends StatefulWidget {
  final List<AlertNotification> alerts;

  const AlertsScreen({
    Key? key,
    required this.alerts,
  }) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _activeFilter = "All";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filtering Alerts
    final filteredAlerts = widget.alerts.where((alert) {
      if (_activeFilter == "All") return true;
      if (_activeFilter == "Critical") return alert.severity == "CRITICAL";
      if (_activeFilter == "Warning") return alert.severity == "WARNING";
      if (_activeFilter == "Info") return alert.severity == "INFO";
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "AI Alerts & Drawer",
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: Column(
          children: [
            // Filter chips header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterChip("All"),
                  _buildFilterChip("Critical"),
                  _buildFilterChip("Warning"),
                  _buildFilterChip("Info"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Alert List View
            Expanded(
              child: filteredAlerts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mark_email_read_rounded,
                            size: 48,
                            color: isDark
                                ? Colors.white.withOpacity(0.24)
                                : Colors.black.withOpacity(0.24),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No alerts found under filter",
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 14, color: AppColors.greyText),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: filteredAlerts.length,
                      itemBuilder: (context, index) {
                        final alert = filteredAlerts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                alert.isUnread = false; // Mark Read on tap
                              });
                            },
                            child: GlassCard(
                              borderRadius: 14,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              borderColor: alert.isUnread
                                  ? alert.severityColor.withOpacity(0.3)
                                  : null,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          alert.severityColor.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(alert.icon,
                                        color: alert.severityColor, size: 20),
                                  ),
                                  const SizedBox(width: 14),

                                  // Content block
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: alert.severityColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                alert.severity,
                                                style: GoogleFonts.spaceGrotesk(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                  color: alert.severityColor,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  alert.time,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    color: isDark
                                                        ? AppColors.greyText
                                                        : AppColors
                                                            .greyTextLight,
                                                  ),
                                                ),
                                                if (alert.isUnread) ...[
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: AppColors
                                                          .electricCyan,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          alert.title,
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white
                                                : AppColors.lightText,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          alert.body,
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            height: 1.3,
                                            color: isDark
                                                ? AppColors.greyText
                                                : AppColors.greyTextLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _activeFilter == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isSelected
              ? Colors.black
              : (isDark ? Colors.white : AppColors.lightText),
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _activeFilter = label;
          });
        }
      },
      selectedColor: AppColors.electricCyan,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }
}
