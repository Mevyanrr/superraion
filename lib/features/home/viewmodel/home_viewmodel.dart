import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../log/service/api_service.dart';
import '../model/home_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeDataModel? _homeData;
  HomeDataModel? get homeData => _homeData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get todayDate => DateFormat('MMMM d, yyyy').format(DateTime.now());

  Future<void> loadFromFirestore() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) { _isLoading = false; notifyListeners(); return; }

      final userDoc = await _firestore
          .collection('user_superraion')
          .doc(user.uid)
          .get();
      final username = userDoc.data()?['displayName']
          ?? user.displayName
          ?? 'User';


      final foodLogs = await _firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('food_log')
          .get();

      final logDates = foodLogs.docs
          .map((doc) => DateTime.tryParse(doc.data()['log_date'] ?? ''))
          .whereType<DateTime>()
          .toList();

      _homeData = HomeDataModel(
        username: username,
        streakCount: _calculateStreak(logDates),
        weekStreak: _generateWeekData(logDates),
      );
    } catch (e) {
      print('loadFromFirestore error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void initHomeData(String authUsername, List<DateTime> historyLogs) {
    _homeData = HomeDataModel(
      username: authUsername,
      streakCount: _calculateStreak(historyLogs),
      weekStreak: _generateWeekData(historyLogs),
    );
    notifyListeners();
  }

  int _calculateStreak(List<DateTime> logs) {
    if (logs.isEmpty) return 0;

    final uniqueDates = logs
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    int count = 1;
    DateTime checkDate = uniqueDates.first;

    for (int i = 1; i < uniqueDates.length; i++) {
      final expected = checkDate.subtract(const Duration(days: 1));
      if (_isSameDay(uniqueDates[i], expected)) {
        count++;
        checkDate = uniqueDates[i];
      } else {
        break;
      }
    }

    return count;
  }

  List<StreakDay> _generateWeekData(List<DateTime> logs) {
    List<StreakDay> days = [];

    if (logs.isEmpty) {
      // Fallback: tampilkan 7 hari sekitar hari ini
      final now = DateTime.now();
      for (int i = -3; i <= 3; i++) {
        final date = now.add(Duration(days: i));
        days.add(StreakDay(
          dayName: DateFormat('E').format(date),
          date: date,
          isLogged: false,
        ));
      }
      return days;
    }


    final uniqueDates = logs
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final center = uniqueDates.first;

    for (int i = -3; i <= 3; i++) {
      final date = center.add(Duration(days: i));
      days.add(StreakDay(
        dayName: DateFormat('E').format(date),
        date: date,
        isLogged: uniqueDates.any((d) => _isSameDay(d, date)),
      ));
    }

    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class InsightViewModel extends ChangeNotifier {
  bool _isFeedbackSubmitted = false;
  bool get isFeedbackSubmitted => _isFeedbackSubmitted;

  void submitFeedback(String type) {

    debugPrint("Feedback received: $type");

    _isFeedbackSubmitted = true;
    notifyListeners();
  }
}

class WeeklySummaryViewModel extends ChangeNotifier {
  WeeklySummaryModel? _summaryData;
  WeeklySummaryModel? get summaryData => _summaryData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final _apiService = ApiService();

  Future<void> fetchWeeklyData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final result = await _apiService.getAnalysis(user.uid);

      if (result != null && result['status'] == 'success') {
        final chartData = result['chart_data'] as List<dynamic>;

        final symptomLevels = chartData.map((day) {
          final scores = [
            (day['skin_score'] as num).toDouble(),
            (day['hair_loss_score'] as num).toDouble(),
            (day['bloating_score'] as num).toDouble(),
            (day['energy_score'] as num).toDouble(),
            (day['weight_score'] as num).toDouble(),
            (day['mood_score'] as num).toDouble(),
            (day['digestion_score'] as num).toDouble(),
          ];
          final avg = scores.reduce((a, b) => a + b) / scores.length;
          return (avg / 2.0).clamp(0.0, 1.0);
        }).toList();


        final days = chartData.map((day) {
          final date = DateTime.parse(day['tanggal']);
          return DateFormat('E').format(date);
        }).toList();


        final lastDay = chartData.last;
        final topSymptom = _getTopSymptom(lastDay);

        _summaryData = WeeklySummaryModel(
          symptomLevels: symptomLevels,
          topFood: topSymptom,
          insight: result['insight'] ?? 'Monitor your symptoms regularly.',
          days: days,
        );
      }
    } catch (e) {
      print('fetchWeeklyData error: $e');

      _fallbackData();
    }

    _isLoading = false;
    notifyListeners();
  }

  String _getTopSymptom(Map<String, dynamic> day) {
    final scores = {
      'Skin':      (day['skin_score'] as num).toDouble(),
      'Hair Loss': (day['hair_loss_score'] as num).toDouble(),
      'Bloating':  (day['bloating_score'] as num).toDouble(),
      'Energy':    (day['energy_score'] as num).toDouble(),
      'Mood':      (day['mood_score'] as num).toDouble(),
      'Digestion': (day['digestion_score'] as num).toDouble(),
    };
    return scores.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  void _fallbackData() {
    final lastSevenDays = List.generate(7, (i) {
      return DateFormat('E').format(
          DateTime.now().subtract(Duration(days: 6 - i)));
    });
    _summaryData = WeeklySummaryModel(
      symptomLevels: [0.4, 0.3, 0.5, 0.8, 0.7, 0.6, 0.9],
      topFood: 'Fastfood',
      insight: 'Fast food may cause breakouts.',
      days: lastSevenDays,
    );
  }
}