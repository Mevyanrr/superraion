import 'package:flutter/material.dart';

class WaterLogModel {
  final double currentAmount;
  final double goalAmount;

  WaterLogModel({required this.currentAmount, required this.goalAmount});
}

class SignalCategory {
  final String title;
  final List<SignalOption> options;

  SignalCategory(this.title, this.options);
}

class SignalOption {
  final String label;
  final String iconPath;

  SignalOption(this.label, this.iconPath);
}

class FoodCategory {
  final String name;
  bool isSelected;

  FoodCategory({
    required this.name,
    this.isSelected = false,
  });
}

//daily habbit
class DailyHabitModel {
  TimeOfDay sleepTime;
  TimeOfDay wakeUpTime;
  int? stressIndex;
  int? exerciseIndex;
  int? caffeineIndex;

  DailyHabitModel({
    required this.sleepTime,
    required this.wakeUpTime,
    this.stressIndex,
    this.exerciseIndex,
    this.caffeineIndex,
  });
}

//RECENT LOG
class RecentLogModel {
  final String mealName;
  final DateTime timestamp;

  RecentLogModel({
    required this.mealName,
    required this.timestamp,
  });
}