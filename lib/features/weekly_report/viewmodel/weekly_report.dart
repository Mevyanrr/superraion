import 'package:flutter/material.dart';
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