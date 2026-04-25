import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:superraion/features/log/service/api_service.dart';
import '../model/weekly_report.dart';

class BodyInsightViewModel extends ChangeNotifier {
  List<BodyInsightItem> _insights = [];
  List<BodyInsightItem> get insights => _insights;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final _apiService = ApiService();

  Future<void> fetchAIInsights() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.getWeeklyReport();

      if (result != null && result['status'] == 'success') {
        final report = result['report'] as Map<String, dynamic>;
        final reportStatus = report['status'];

        if (reportStatus == 'ok') {
          final insights = report['insights'] as List<dynamic>? ?? [];
          if (insights.isNotEmpty) {
            _insights = insights.map((item) => BodyInsightItem(
              type: InsightType.info,
              text: '${item['headline']}\n${item['explanation']}',
            )).toList();
          } else {
            _insights = [BodyInsightItem(
              type: InsightType.info,
              text: 'AI sudah analisis tapi belum ada pola yang cukup kuat.',
            )];
          }
        } else {
          _insights = [BodyInsightItem(
            type: InsightType.info,
            text: report['message'] ?? 'Lanjut log beberapa hari lagi ya!',
          )];
        }
      } else {
        _fallbackInsights();
      }
    } catch (e) {
      print('fetchAIInsights error: $e');
      _fallbackInsights();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _fallbackInsights() {
    _insights = [
      BodyInsightItem(
        type: InsightType.warning,
        text: "Symptoms like breakouts and mood changes tend to appear after certain eating patterns.",
      ),
      BodyInsightItem(
        type: InsightType.info,
        text: "Keep logging to get personalized AI insights!",
      ),
    ];
  }
}

class WeeklyAnalysisViewModel extends ChangeNotifier {
  List<FoodStat> _foodStats = [];
  List<FoodStat> get foodStats => _foodStats;

  List<TipModel> _tips = [];
  List<TipModel> get tips => _tips;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final _apiService = ApiService();

  Future<void> fetchWeeklyAnalysis() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.getWeeklyReport();

      if (result != null && result['status'] == 'success') {
        final report = result['report'] as Map<String, dynamic>;
        final reportStatus = report['status'];

        if (reportStatus == 'ok') {
          final correlations = report['correlations'] as List<dynamic>? ?? [];
          final colors = [
            [const Color(0xFFFEE6E3), const Color(0xFFF87171)],
            [const Color(0xFFE0F2FE), const Color(0xFF60A5FA)],
            [const Color(0xFFDCFCE7), const Color(0xFF4ADE80)],
          ];

          // Ambil trigger unik
          final seen = <String>{};
          final unique = correlations.where((c) {
            final key = '${c['trigger']}_${c['symptom']}';
            return seen.add(key);
          }).take(3).toList();

          _foodStats = unique.asMap().entries.map((e) {
            final idx = e.key;
            final item = e.value;
            return FoodStat(
              title: item['trigger'] ?? '',
              count: item['direction'] ?? '',
              bgColor: colors[idx % colors.length][0],
              textColor: colors[idx % colors.length][1],
            );
          }).toList();

          final insights = report['insights'] as List<dynamic>? ?? [];
          _tips = insights.take(2).map((item) => TipModel(
            title: item['headline'] ?? '',
            subtitle: item['explanation'] ?? '',
            highlight: item['recommendation'] ?? '',
          )).toList();

          if (_foodStats.isEmpty) _fallbackFoodStats();
          if (_tips.isEmpty) _fallbackTips();
        } else {
          _fallbackFoodStats();
          _fallbackTips();
        }
      } else {
        _fallbackFoodStats();
        _fallbackTips();
      }
    } catch (e) {
      print('fetchWeeklyAnalysis error: $e');
      _fallbackFoodStats();
      _fallbackTips();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _fallbackFoodStats() {
    _foodStats = [
      FoodStat(title: "Dairy", count: "8 times", bgColor: const Color(0xFFFEE6E3), textColor: const Color(0xFFF87171)),
      FoodStat(title: "Gluten", count: "5 times", bgColor: const Color(0xFFE0F2FE), textColor: const Color(0xFF60A5FA)),
      FoodStat(title: "Fried", count: "3 times", bgColor: const Color(0xFFDCFCE7), textColor: const Color(0xFF4ADE80)),
    ];
  }

  void _fallbackTips() {
    _tips = [
      TipModel(title: "Increase Hydration", subtitle: "Health Specialist", highlight: "+2 Glasses"),
      TipModel(title: "Sleep", subtitle: "Helps stabilize mood changes", highlight: "+30 Minutes"),
    ];
  }

  void init() => notifyListeners();
}

class WeeklyReportViewModel extends ChangeNotifier {
  String get reportTitle => "Weekly Report";

  String get dateRange {
    DateTime now = DateTime.now();
    DateTime lastWeek = now.subtract(const Duration(days: 7));
    String start = DateFormat('d MMMM').format(lastWeek);
    String end = DateFormat('d MMMM yyyy').format(now);
    return "$start - $end";
  }
}

class MedicalNoteViewModel extends ChangeNotifier {
  MedicalNoteModel? _note;
  MedicalNoteModel? get note => _note;

  void fetchMedicalNote() {
    _note = MedicalNoteModel(
      title: "Medical Note",
      description: "This is not a medical diagnosis. If symptoms continue, consider consulting a healthcare professional.",
    );
    notifyListeners();
  }
}