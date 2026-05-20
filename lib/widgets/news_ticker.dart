import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';
import 'pulsing_indicator.dart';

// ==========================================
// Horizontal Auto-Scrolling News Ticker
// ==========================================
class NewsTicker extends StatefulWidget {
  final List<String> headlines;

  const NewsTicker({Key? key, required this.headlines}) : super(key: key);

  @override
  State<NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends State<NewsTicker> {
  late ScrollController _scrollController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0.0);
        } else {
          _scrollController.animateTo(
            currentScroll + 1.0,
            duration: const Duration(milliseconds: 30),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant NewsTicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.headlines != widget.headlines) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.08)),
          bottom: BorderSide(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.08)),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.headlines.length * 100, // pseudo-infinite
        itemBuilder: (context, index) {
          final headline = widget.headlines[index % widget.headlines.length];
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                const PulsingIndicator(color: AppColors.electricCyan, size: 6),
                const SizedBox(width: 10),
                Text(
                  headline,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withOpacity(0.9)
                        : AppColors.lightText.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

