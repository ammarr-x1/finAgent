import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

// ==========================================
// Shared Data Structures and Models
// ==========================================
class TraceStep {
  final String time;
  final String agentName;
  final String status;
  final String reasoning;
  final Color color;
  bool isCompleted;

  TraceStep({
    required this.time,
    required this.agentName,
    required this.status,
    required this.reasoning,
    required this.color,
    this.isCompleted = false,
  });
}

class AlertNotification {
  final IconData icon;
  final String title;
  final String body;
  final String time;
  final String severity;
  final Color severityColor;
  bool isUnread;

  AlertNotification({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.severity,
    required this.severityColor,
    this.isUnread = true,
  });
}

