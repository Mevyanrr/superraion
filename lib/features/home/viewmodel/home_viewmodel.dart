import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/home_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeDataModel? _homeData;
  HomeDataModel? get homeData => _homeData;

  String get todayDate => DateFormat('MMMM d, yyyy').format(DateTime.now());

  void initHomeData(String authUsername, List<DateTime> historyLogs) {
    // Logika Streak
    int streak = _calculateStreak(historyLogs);
    List<StreakDay> week = _generateWeekData(historyLogs);

    _homeData = HomeDataModel(
      username: authUsername,
      streakCount: streak,
      weekStreak: week,
    );
    notifyListeners();
  }

  int _calculateStreak(List<DateTime> logs) {
    if (logs.isEmpty) return 0;
    logs.sort((a, b) => b.compareTo(a));

    int count = 0;
    DateTime checkDate = DateTime.now();

    bool hasLogToday = logs.any((d) => _isSameDay(d, checkDate));
    if (!hasLogToday) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    for (var log in logs) {
      if (_isSameDay(log, checkDate)) {
        count++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    }
    return count;
  }

  List<StreakDay> _generateWeekData(List<DateTime> logs) {
    List<StreakDay> days = [];
    DateTime now = DateTime.now();

    for (int i = -3; i <= 3; i++) {
      DateTime date = now.add(Duration(days: i));
      days.add(StreakDay(
        dayName: DateFormat('E').format(date),
        date: date,
        isLogged: logs.any((d) => _isSameDay(d, date)),
      ));
    }
    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class InsightViewModel extends ChangeNotifier {
  bool _isFeedbackSubmitted = false;
  bool get isFeedbackSubmitted => _isFeedbackSubmitted;

  void submitFeedback(String type) {
    // Logika untuk API call atau State Management
    debugPrint("Feedback received: $type");

    _isFeedbackSubmitted = true;
    notifyListeners();
  }
}

//SUMMARY
class WeeklySummaryViewModel extends ChangeNotifier {
  WeeklySummaryModel? _summaryData;
  WeeklySummaryModel? get summaryData => _summaryData;

  void fetchWeeklyData() {
    // Simulasi pengambilan data 7 hari terakhir
    List<String> lastSevenDays = List.generate(7, (index) {
      DateTime date = DateTime.now().subtract(Duration(days: 6 - index));
      return DateFormat('E').format(date); // Mon, Tue, dst.
    });

    // Simulasi data dari AI & Backend
    _summaryData = WeeklySummaryModel(
      symptomLevels: [0.4, 0.3, 0.5, 0.8, 0.7, 0.6, 0.9], // AI Data
      topFood: "Fastfood",                              // Backend
      insight: "Fast food may cause breakouts.",        // Backend
      days: lastSevenDays,
    );
    notifyListeners();
  }
}