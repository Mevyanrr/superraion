// lib/features/log/viewmodel/log_view_model.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/log_model.dart';

class LogViewModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  String get formattedDate => DateFormat('MMMM d, yyyy').format(_selectedDate);

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFF4C66CD)), // Sesuaikan dengan warna app
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  double _currentMl = 0.0;
  final double _goalMl = 4000.0; // 4 Liter

  double get currentMl => _currentMl;
  double get progress => (_currentMl / _goalMl).clamp(0.0, 1.0);
  String get formattedLiters => "${(_currentMl / 1000).toStringAsFixed(1)} L Logged";

  // Logic penentuan status berdasarkan progress
  String get status {
    if (progress < 0.25) return "Low";
    if (progress < 0.75) return "Medium";
    return "High";
  }

  void addWater() {
    if (_currentMl < _goalMl) {
      _currentMl += 250;
      notifyListeners();
    }
  }

  //BODY SIGNAL
  void removeWater() {
    if (_currentMl >= 250) {
      _currentMl -= 250;
      notifyListeners();
    }
  }

  final Map<String, int?> _selectedOptions = {};

  int? getSelectedIndex(String category) => _selectedOptions[category];

  void selectOption(String category, int index) {
    _selectedOptions[category] = index;
    notifyListeners();
  }
}

//FOOD
class FoodIntakeViewModel extends ChangeNotifier {
  // Data Kategori
  final List<FoodCategory> _categories = [
    'Protein', 'Refined', 'Supplements',
    'Carbs', 'Drinks', 'Fastfood',
    'Sweets', 'Dairy', 'Fried',
  ].map((name) => FoodCategory(name: name)).toList();

  // State untuk animasi tekan (UI State)
  final Set<String> _pressingCategories = {};

  // Controller untuk Text
  final TextEditingController detailsController = TextEditingController();

  // Getters
  List<FoodCategory> get categories => _categories;
  Set<String> get pressingCategories => _pressingCategories;

  // Actions
  void toggleCategory(int index) {
    _categories[index].isSelected = !_categories[index].isSelected;
    notifyListeners();
  }

  void setPressing(String name, bool isPressing) {
    if (isPressing) {
      _pressingCategories.add(name);
    } else {
      _pressingCategories.remove(name);
    }
    notifyListeners();
  }

  // Method untuk submit data (Contoh Clean Architecture)
  void submitIntake() {
    final selectedNames = _categories
        .where((cat) => cat.isSelected)
        .map((cat) => cat.name)
        .toList();

    print("Selected: $selectedNames");
    print("Details: ${detailsController.text}");
    // Panggil Repository/Service di sini
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }
}


class DailyHabitViewModel extends ChangeNotifier {
  final DailyHabitModel _habit = DailyHabitModel(
    sleepTime: const TimeOfDay(hour: 22, minute: 0),
    wakeUpTime: const TimeOfDay(hour: 7, minute: 0),
  );

  DailyHabitModel get habit => _habit;

  // Logic Pemilihan Waktu
  Future<void> selectTime(BuildContext context, bool isSleepTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isSleepTime ? _habit.sleepTime : _habit.wakeUpTime,
    );
    if (picked != null) {
      if (isSleepTime) _habit.sleepTime = picked;
      else _habit.wakeUpTime = picked;
      notifyListeners();
    }
  }

  void setStress(int index) { _habit.stressIndex = index; notifyListeners(); }
  void setExercise(int index) { _habit.exerciseIndex = index; notifyListeners(); }
  void setCaffeine(int index) { _habit.caffeineIndex = index; notifyListeners(); }

  // Get Colors based on Position (Index)
  Color getBgColor(int index, bool isSelected) {
    if (!isSelected) return const Color(0xFFF9FAFB);
    if (index == 0) return const Color(0xFFE8F5E9);
    if (index == 1) return const Color(0xFFFFF9C4);
    return const Color(0xFFFFEBEE);
  }

  Color getTextColor(int index, bool isSelected) {
    if (!isSelected) return const Color(0xFF111827);
    if (index == 0) return const Color(0xFF2E7D32);
    if (index == 1) return const Color(0xFFF57F17);
    return const Color(0xFFC62828);
  }
}



class RecentLogViewModel extends ChangeNotifier {

  RecentLogModel? _recentLog = RecentLogModel(
    mealName: "Chicken Salad",
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
  );

  RecentLogModel? get recentLog => _recentLog;

  String getTimeAgo() {
    if (_recentLog == null) return "No logs yet";
    final diff = DateTime.now().difference(_recentLog!.timestamp);

    if (diff.inHours >= 1) {
      return "${diff.inHours} h ago";
    } else {
      return "${diff.inMinutes} m ago";
    }
  }

  void navigateToDetail(BuildContext context) {

  }
}



