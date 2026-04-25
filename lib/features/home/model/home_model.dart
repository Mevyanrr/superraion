import 'package:flutter/material.dart';

class StreakDay {
  final String dayName;
  final DateTime date;
  bool isLogged;

  StreakDay({
    required this.dayName,
    required this.date,
    this.isLogged = false,
  });
}

class HomeDataModel {
  final String username;
  final int streakCount;
  final List<StreakDay> weekStreak;

  HomeDataModel({
    required this.username,
    required this.streakCount,
    required this.weekStreak,
  });
}

class WeeklySummaryModel {
  final List<double> symptomLevels;
  final String topFood;
  final String insight;
  final List<String> days;

  WeeklySummaryModel({
    required this.symptomLevels,
    required this.topFood,
    required this.insight,
    required this.days,
  });
}