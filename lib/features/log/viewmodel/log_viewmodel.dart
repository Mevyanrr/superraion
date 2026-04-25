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
            colorScheme: const ColorScheme.light(primary: Color(0xFF4C66CD)),
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

  // ─── WATER ───────────────────────────────────────────
  double _currentMl = 0.0;
  final double _goalMl = 4000.0;

  double get currentMl => _currentMl;
  int get waterMl => _currentMl.toInt();
  double get progress => (_currentMl / _goalMl).clamp(0.0, 1.0);
  String get formattedLiters => "${(_currentMl / 1000).toStringAsFixed(1)} L Logged";

  String get status {
    if (progress < 0.25) return "Low";
    if (progress < 0.75) return "Medium";
    return "High";
  }

  void addWater() {
    if (_currentMl < _goalMl) { _currentMl += 250; notifyListeners(); }
  }

  void removeWater() {
    if (_currentMl >= 250) { _currentMl -= 250; notifyListeners(); }
  }

  // ─── BODY SIGNAL ─────────────────────────────────────
  final Map<String, int?> _selectedOptions = {};

  int? getSelectedIndex(String category) => _selectedOptions[category];

  void selectOption(String category, int index) {
    _selectedOptions[category] = index;
    notifyListeners();
  }



  // Konversi index → string label untuk dikirim ke API
  Map<String, String?> get bodySignals {
    const labelMap = {
      'Acne':           ['Clear', 'Mild', 'Severe'],
      'Hair Loss':      ['Normal', 'Increased', 'Heavy'],
      'Bloating Level': ['None', 'Mild', 'Severe'],
      'Mood':           ['Stable', 'Fluctuating', 'Bad'],
      'Energy Level':   ['High', 'Okay', 'Low'],
      'Weight':         ['Stable', 'Slight', 'High'],
      'Digestion':      ['Normal', 'Irregular', 'Diarrhea'],
    };
    return labelMap.map((key, labels) {
      final idx = _selectedOptions[key];
      return MapEntry(key, idx != null ? labels[idx] : null);
    });
  }
  void reset() {
    _selectedDate = DateTime.now();
    _currentMl = 0.0;
    _selectedOptions.clear();
    notifyListeners();
  }
}


class FoodIntakeViewModel extends ChangeNotifier {
  final List<FoodCategory> _categories = [
    'Protein', 'Refined', 'Supplements',
    'Carbs', 'Drinks', 'Fastfood',
    'Sweets', 'Dairy', 'Fried',
  ].map((name) => FoodCategory(name: name)).toList();

  final Set<String> _pressingCategories = {};
  final TextEditingController detailsController = TextEditingController();

  List<FoodCategory> get categories => _categories;
  Set<String> get pressingCategories => _pressingCategories;

  // Getter untuk _handleSave
  List<String> get selectedFoodCategories => _categories
      .where((cat) => cat.isSelected)
      .map((cat) => cat.name)
      .toList();

  String get foodDetail => detailsController.text;

  void toggleCategory(int index) {
    _categories[index].isSelected = !_categories[index].isSelected;
    notifyListeners();
  }

  void setPressing(String name, bool isPressing) {
    isPressing ? _pressingCategories.add(name) : _pressingCategories.remove(name);
    notifyListeners();
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  void reset() {
    for (var cat in _categories) {
      cat.isSelected = false;
    }
    _pressingCategories.clear();
    detailsController.clear();
    notifyListeners();
  }
}

// ─── HABIT ────────────────────────────────────────────
class DailyHabitViewModel extends ChangeNotifier {
  final DailyHabitModel _habit = DailyHabitModel(
    sleepTime: const TimeOfDay(hour: 22, minute: 0),
    wakeUpTime: const TimeOfDay(hour: 7, minute: 0),
  );

  DailyHabitModel get habit => _habit;

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

  void setStress(int index)   { _habit.stressIndex = index;   notifyListeners(); }
  void setExercise(int index) { _habit.exerciseIndex = index; notifyListeners(); }
  void setCaffeine(int index) { _habit.caffeineIndex = index; notifyListeners(); }

  // Getter untuk _handleSave
  String? get stresshigh => _habit.stressIndex == 2 ? 'High' : null;
  String? get moderate   => _habit.stressIndex == 1 ? 'Moderate' : null;
  String? get relaxed    => _habit.stressIndex == 0 ? 'Relaxed' : null;
  String? get active     => _habit.exerciseIndex == 0 ? 'Active' : null;
  String? get light      => _habit.exerciseIndex == 1 ? 'Light' : null;
  String? get none       => _habit.exerciseIndex == 2 ? 'None' : null;
  String get tidurMulaiStr {
    final t = _habit.sleepTime;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  String get tidurSelesaiStr {
    final t = _habit.wakeUpTime;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  double get durasiJam {
    final sleep = _habit.sleepTime;
    final wake  = _habit.wakeUpTime;
    double sleepMin = sleep.hour * 60 + sleep.minute.toDouble();
    double wakeMin  = wake.hour  * 60 + wake.minute.toDouble();
    if (wakeMin < sleepMin) wakeMin += 24 * 60; // overnight
    return (wakeMin - sleepMin) / 60;
  }

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

  void reset() {
    _habit.sleepTime = const TimeOfDay(hour: 22, minute: 0);
    _habit.wakeUpTime = const TimeOfDay(hour: 7, minute: 0);
    _habit.stressIndex = -1;
    _habit.exerciseIndex = -1;
    _habit.caffeineIndex = -1;
    notifyListeners();
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