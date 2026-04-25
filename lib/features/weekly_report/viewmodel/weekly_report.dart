import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/weekly_report.dart';

class BodyInsightViewModel extends ChangeNotifier {
  List<BodyInsightItem> _insights = [];
  List<BodyInsightItem> get insights => _insights;

  void fetchAIInsights() {
    // Simulasi data dari tim AI
    _insights = [
      BodyInsightItem(
        type: InsightType.warning,
        text: "Symptoms like *breakouts* and *mood changes* tend to appear after certain eating patterns.",
      ),
      BodyInsightItem(
        type: InsightType.warning,
        text: "On days you consumed *Dairy*, your *bloating symptoms increased by 40%* the following morning.",
      ),
      BodyInsightItem(
        type: InsightType.info,
        text: "This suggests that your gut condition, along with your daily habits, may be influencing how your body feels.",
      ),
    ];
    notifyListeners();
  }
}

class WeeklyAnalysisViewModel extends ChangeNotifier {
  // Data Most Consumed (Backend/AI)
  final List<FoodStat> foodStats = [
    FoodStat(title: "Diary", count: "8 times", bgColor: const Color(0xFFFEE6E3), textColor: const Color(0xFFF87171)),
    FoodStat(title: "Gluten", count: "5 times", bgColor: const Color(0xFFE0F2FE), textColor: const Color(0xFF60A5FA)),
    FoodStat(title: "Fried", count: "3 times", bgColor: const Color(0xFFDCFCE7), textColor: const Color(0xFF4ADE80)),
  ];

  // Data Tips (AI)
  final List<TipModel> tips = [
    TipModel(title: "Increase Hydration", subtitle: "Health Specialist", highlight: "+2 Glasses"),
    TipModel(title: "Sleep", subtitle: "Helps stabilize mood changes", highlight: "+30 Minutes"),
  ];

  void init() {
    notifyListeners();
  }
}

//INI APPBAR

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
    // Simulasi data dari Backend
    _note = MedicalNoteModel(
      title: "Medical Note",
      description: "This is not a medical diagnosis. If symptoms continue, consider consulting a healthcare professional.",
    );
    notifyListeners();
  }
}