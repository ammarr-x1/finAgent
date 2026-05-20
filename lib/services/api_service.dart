import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';

class ApiService {
  static const String host = "localhost:8000";
  static const String baseUrl = "http://$host";
  static const String wsUrl = "ws://$host/api/v1/stream";

  // Trigger the 8-agent pipeline run
  static Future<String?> triggerPipeline() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/pipeline/run"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["run_id"] as String?;
      } else {
        debugPrint("Error triggering pipeline: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Failed to trigger pipeline: $e");
    }
    return null;
  }

  // Get active portfolio state
  static Future<Map<String, dynamic>?> getPortfolio({String? runId}) async {
    try {
      final uri = runId != null 
          ? Uri.parse("$baseUrl/api/v1/portfolio?run_id=$runId")
          : Uri.parse("$baseUrl/api/v1/portfolio");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("Failed to fetch portfolio: $e");
    }
    return null;
  }

  // Reset portfolio to defaults
  static Future<Map<String, dynamic>?> resetPortfolio() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/portfolio/reset"),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("Failed to reset portfolio: $e");
    }
    return null;
  }

  // Fetch real-time live news headlines
  static Future<List<String>> getLiveNewsHeadlines() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/v1/news/headlines"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["headlines"] as List<dynamic>?;
        if (list != null) {
          return list.map((e) => e.toString()).toList();
        }
      }
    } catch (e) {
      debugPrint("Failed to fetch live news: $e");
    }
    return [];
  }

  // Fetch real-time live market prices
  static Future<Map<String, dynamic>?> getMarketPrices() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/v1/market/prices"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["prices"] as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint("Failed to fetch market prices: $e");
    }
    return null;
  }

  // Fetch latest AI insight details
  static Future<Map<String, dynamic>?> getLatestInsight() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/v1/insight/latest"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["insight"] as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint("Failed to fetch latest insight: $e");
    }
    return null;
  }

  // Fetch latest executed trades
  static Future<List<dynamic>> getLatestTrades() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/v1/trades/latest"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["trades"] as List<dynamic>?;
        if (list != null) {
          return list;
        }
      }
    } catch (e) {
      debugPrint("Failed to fetch latest trades: $e");
    }
    return [];
  }

  // Fetch latest full execution details
  static Future<Map<String, dynamic>?> getLatestExecution() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/v1/execution/latest"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["execution"] as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint("Failed to fetch latest execution: $e");
    }
    return null;
  }

  // Establish a live WebSocket stream
  static WebSocketChannel connectWebSocket() {
    return WebSocketChannel.connect(Uri.parse(wsUrl));
  }
}
