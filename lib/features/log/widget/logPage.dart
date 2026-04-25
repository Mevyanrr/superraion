import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:superraion/features/log/service/api_service.dart';
import '../service/food_log.dart';
import '../service/habit_log.dart';
import '../service/log_mapper.dart';
import '../service/symptom_log.dart';
import 'body_signal.dart';
import 'food_intake.dart';
import 'water_intake.dart';
import 'habit_intake.dart';

class TodayLogPage extends StatefulWidget {
  const TodayLogPage({super.key});

  @override
  State<TodayLogPage> createState() => _TodayLogPageState();
}

class _TodayLogPageState extends State<TodayLogPage> {
  List<String> _foodCategories = [];
  String _foodDetail = '';
  int _waterMl = 0;
  Map<String, String?> _bodySignals = {};
  String _tidurMulai = '22:00';
  String _tidurSelesai = '06:00';
  double _durasiJam = 8.0;
  String? _relaxed, _moderate, _stresshigh, _stresslow;
  String? _active, _light, _none;
  String? _energyhigh, _energylow;
  final _apiService = ApiService();


  bool _isSaving = false;

  final _foodLog = FoodLog();
  final _habitLog = HabitLog();
  final _symptomLog = SymptomLog();


  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    final results = await Future.wait([
      _foodLog.saveDailyLog(
        foodCategories: _foodCategories,
        foodDetail: _foodDetail,
        waterMl: _waterMl,
      ),
      _symptomLog.saveSymptom(_bodySignals),
      _habitLog.saveHabit(
        tidurMulai: _tidurMulai,
        tidurSelesai: _tidurSelesai,
        durasiJam: _durasiJam,
        relaxed: _relaxed,
        moderate: _moderate,
        stresshigh: _stresshigh,
        stresslow: _stresslow,
        active: _active,
        light: _light,
        none: _none,
        energyhigh: _energyhigh,
        energylow: _energylow,
      ),
      _apiService.submitDailyLog(
        logDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        foodCategories: _foodCategories,
        foodDetail: _foodDetail,
        signals: _bodySignals,
        durasiJam: _durasiJam,
        waterMl: _waterMl,
        stresshigh: _stresshigh,
        moderate: _moderate,
        relaxed: _relaxed,
        active: _active,
        light: _light,
        none: _none,
        energyhigh: _energyhigh,
        energylow: _energylow,
      ),
    ]);

    setState(() => _isSaving = false);

    final allSuccess = results.every((r) => r == true);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(allSuccess
            ? 'Log tersimpan & dikirim ke analisis!'
            : 'Sebagian gagal, coba lagi'),
        backgroundColor: allSuccess ? const Color(0xFF6366F1) : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.chevron_left,
                          color: Color(0xFF6366F1), size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Today's Log",
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827))),
                      Text(
                        DateFormat('MMMM d, yyyy').format(DateTime.now()),
                        style: const TextStyle(fontSize: 13,
                            color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_today_outlined,
                        color: Color(0xFF6366F1), size: 18),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  children: [
                    FoodIntake(
                      onChanged: (cats, detail) {
                        _foodCategories = cats;
                        _foodDetail = detail;
                      },
                    ),
                    const SizedBox(height: 16),
                    WaterIntake(
                      onChanged: (ml) => _waterMl = ml,
                    ),
                    const SizedBox(height: 16),
                    HabitIntake(
                      onChanged: (mulai, selesai, durasi, {
                        relaxed, moderate, stresshigh, stresslow,
                        active, light, none,
                        energyhigh, energylow,
                      }) {
                        _tidurMulai = mulai;
                        _tidurSelesai = selesai;
                        _durasiJam = durasi;
                        _relaxed = relaxed;
                        _moderate = moderate;
                        _stresshigh = stresshigh;
                        _stresslow = stresslow;
                        _active = active;
                        _light = light;
                        _none = none;
                        _energyhigh = energyhigh;
                        _energylow = energylow;
                      },
                    ),

                    const SizedBox(height: 16),
                    BodySignals(
                      onChanged: (signals) => _bodySignals = signals,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: GestureDetector(
          onTap: _isSaving ? null : _handleSave,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 52,
            decoration: BoxDecoration(
              color: _isSaving
                  ? const Color(0xFF6366F1).withOpacity(0.6)
                  : const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: _isSaving
                  ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
                  : const Text('Save Log',
                  style: TextStyle(color: Colors.white,
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}