import 'package:flutter/material.dart';

class WaterLogModel {
  final double currentAmount; // dalam liter
  final double goalAmount;    // 4.0 Liter

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
  int? stressIndex;     // 0: Relaxed, 1: Moderate, 2: High
  int? exerciseIndex;   // 0: Active, 1: Light, 2: None
  int? caffeineIndex;   // 0: None, 1: Low, 2: High

  DailyHabitModel({
    required this.sleepTime,
    required this.wakeUpTime,
    this.stressIndex,
    this.exerciseIndex,
    this.caffeineIndex,
  });
}