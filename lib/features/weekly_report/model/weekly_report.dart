import 'dart:ui';

enum InsightType { warning, info }

class BodyInsightItem {
  final String text; // Teks mentah dari AI
  final InsightType type;

  BodyInsightItem({required this.text, required this.type});
}

class FoodStat {
  final String title;
  final String count;
  final Color bgColor;
  final Color textColor;

  FoodStat({required this.title, required this.count, required this.bgColor, required this.textColor});
}

class TipModel {
  final String title;
  final String subtitle;
  final String highlight;

  TipModel({required this.title, required this.subtitle, required this.highlight});
}

class WeeklyReportHeader {
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  WeeklyReportHeader({
    required this.title,
    required this.startDate,
    required this.endDate,
  });
}

class MedicalNoteModel {
  final String title;
  final String description;

  MedicalNoteModel({
    required this.title,
    required this.description,
  });
}