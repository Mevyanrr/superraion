import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/log_model.dart';
import 'package:provider/provider.dart';
import 'package:superraion/features/log/viewmodel/log_viewmodel.dart';

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

  Future<void> loadLogByDate(String logDate) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Load water dari food_log
      final foodSnap = await firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('food_log')
          .where('log_date', isEqualTo: logDate)
          .limit(1)
          .get();

      if (foodSnap.docs.isNotEmpty) {
        final data = foodSnap.docs.first.data();
        _currentMl = (data['water_ml'] ?? 0).toDouble();
      }

      // Load body signals dari symptom_log
      final symptomSnap = await firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('symptom_log')
          .where('log_date', isEqualTo: logDate)
          .limit(1)
          .get();

      if (symptomSnap.docs.isNotEmpty) {
        final data = symptomSnap.docs.first.data();
        const indexMap = {
          'Acne':           {'Clear': 0, 'Mild': 1, 'Severe': 2},
          'Hair Loss':      {'Normal': 0, 'Increased': 1, 'Heavy': 2},
          'Bloating Level': {'None': 0, 'Mild': 1, 'Severe': 2},
          'Mood':           {'Stable': 0, 'Fluctuating': 1, 'Bad': 2},
          'Energy Level':   {'High': 0, 'Okay': 1, 'Low': 2},
          'Weight':         {'Stable': 0, 'Slight': 1, 'High': 2},
          'Digestion':      {'Normal': 0, 'Irregular': 1, 'Diarrhea': 2},
        };

        final fieldMap = {
          'Acne':           data['acne'],
          'Hair Loss':      data['hair_loss'],
          'Bloating Level': data['bloating_level'],
          'Mood':           data['mood'],
          'Energy Level':   data['energy_level'],
          'Weight':         data['weight'],
          'Digestion':      data['digestion'],
        };

        fieldMap.forEach((category, value) {
          if (value != null) {
            final idx = indexMap[category]?[value];
            if (idx != null) _selectedOptions[category] = idx;
          }
        });
      }

      notifyListeners();
    } catch (e) {
      print('loadLogByDate error: $e');
    }
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
  Future<void> loadFoodByDate(String logDate) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snap = await firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('food_log')
          .where('log_date', isEqualTo: logDate)
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        final data = snap.docs.first.data();
        final categories = List<String>.from(data['categories'] ?? []);
        final detail = data['detail'] as String? ?? '';

        for (var cat in _categories) {
          cat.isSelected = categories.contains(cat.name);
        }
        detailsController.text = detail;
        notifyListeners();
      }
    } catch (e) {
      print('loadFoodByDate error: $e');
    }
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

  Future<void> loadHabitByDate(String logDate) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snap = await firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('habit_log')
          .where('log_date', isEqualTo: logDate)
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        final data = snap.docs.first.data();


        final mulai = data['tidur_mulai'] as String? ?? '22:00';
        final selesai = data['tidur_selesai'] as String? ?? '07:00';
        final mulaiParts = mulai.split(':');
        final selesaiParts = selesai.split(':');

        _habit.sleepTime = TimeOfDay(
          hour: int.parse(mulaiParts[0]),
          minute: int.parse(mulaiParts[1]),
        );
        _habit.wakeUpTime = TimeOfDay(
          hour: int.parse(selesaiParts[0]),
          minute: int.parse(selesaiParts[1]),
        );

        // Stress
        if (data['stresshigh'] != null) _habit.stressIndex = 2;
        else if (data['moderate'] != null) _habit.stressIndex = 1;
        else if (data['relaxed'] != null) _habit.stressIndex = 0;
        else _habit.stressIndex = -1;

        // Exercise
        if (data['active'] != null) _habit.exerciseIndex = 0;
        else if (data['light'] != null) _habit.exerciseIndex = 1;
        else if (data['none'] != null) _habit.exerciseIndex = 2;
        else _habit.exerciseIndex = -1;

        notifyListeners();
      }
    } catch (e) {
      print('loadHabitByDate error: $e');
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
  RecentLogModel? _recentLog;
  RecentLogModel? get recentLog => _recentLog;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _recentLogDate;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> loadRecentLog() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final snap = await _firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('food_log')
          .orderBy('created_at', descending: true)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) {
        _recentLog = null;
      } else {
        final data = snap.docs.first.data();
        final categories = List<String>.from(data['categories'] ?? []);
        final detail = data['detail'] as String? ?? '';
        final createdAt = data['created_at'] != null
            ? (data['created_at'] as Timestamp).toDate()
            : DateTime.now();

        final mealName = detail.isNotEmpty
            ? detail
            : categories.isNotEmpty
            ? categories.join(', ')
            : 'No food logged';

        _recentLog = RecentLogModel(
          mealName: mealName,
          timestamp: createdAt,
        );
      }

      if (snap.docs.isNotEmpty) {
        final data = snap.docs.first.data();
        _recentLogDate = data['log_date'] as String?;
      }
    } catch (e) {
      print('loadRecentLog error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  String getTimeAgo() {
    if (_recentLog == null) return 'No logs yet';
    final diff = DateTime.now().difference(_recentLog!.timestamp);
    if (diff.inDays >= 1) return '${diff.inDays} d ago';
    if (diff.inHours >= 1) return '${diff.inHours} h ago';
    return '${diff.inMinutes} m ago';
  }

  Future<void> navigateToDetail(BuildContext context) async {
    if (_recentLog == null || _recentLogDate == null) return;


    await Future.wait([
      context.read<LogViewModel>().loadLogByDate(_recentLogDate!),
      context.read<FoodIntakeViewModel>().loadFoodByDate(_recentLogDate!),
      context.read<DailyHabitViewModel>().loadHabitByDate(_recentLogDate!),
    ]);

    if (!context.mounted) return;
    Navigator.pushNamed(context, '/log', arguments: {'fromRecent': true});
  }

}