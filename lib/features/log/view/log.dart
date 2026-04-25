import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:superraion/features/log/widget/daily_habbit.dart';
import 'package:superraion/features/log/widget/food.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/widgets/popup.dart';
import '../service/api_service.dart';
import '../service/food_log.dart';
import '../service/habit_log.dart';
import '../service/symptom_log.dart';
import '../viewmodel/log_viewmodel.dart';
import '../widget/water_intake.dart';
import '../widget/body_signal.dart';

class Log extends StatefulWidget {
  const Log({Key? key}) : super(key: key);

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  final _apiService = ApiService();
  bool _isSaving = false;
  final _foodLog    = FoodLog();
  final _symptomLog = SymptomLog();
  final _habitLog   = HabitLog();


  final List<Map<String, dynamic>> bodySignalConfigs = const [
    {
      "category": "Bloating Level",
      "labels": ["None", "Mild", "Severe"],
      "images": ["assets/images/booting1.png", "assets/images/booting2.png", "assets/images/booting3.png"]
    },
    {
      "category": "Energy Level",
      "labels": ["High", "Okay", "Low"],
      "images": ["assets/images/energylow.png", "assets/images/energymed.png", "assets/images/energyhigh.png"]
    },
    {
      "category": "Acne",
      "labels": ["Clear", "Mild", "Severe"],
      "images": ["assets/images/acneclear.png", "assets/images/acnemild.png", "assets/images/acnesevere.png"]
    },
    {
      "category": "Mood",
      "labels": ["Stable", "Fluctuating", "Bad"],
      "images": ["assets/images/moodstable.png", "assets/images/moodfluc.png", "assets/images/moodbad.png"]
    },
    {
      "category": "Hair Loss",
      "labels": ["Normal", "Increased", "Heavy"],
      "images": ["assets/images/hairnormal.png", "assets/images/hairincrease.png", "assets/images/hairheavy.png"]
    },
    {
      "category": "Weight",
      "labels": ["Stable", "Slight", "High"],
      "images": ["assets/images/weightstable.png", "assets/images/weightslight.png", "assets/images/weighthigh.png"]
    },
    {
      "category": "Digestion",
      "labels": ["Normal", "Irregular", "Diarrhea"],
      "images": ["assets/images/poopnormal.png", "assets/images/poopireg.png", "assets/images/poopdiare.png"]
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogViewModel>().reset();
      context.read<FoodIntakeViewModel>().reset();
      context.read<DailyHabitViewModel>().reset();
    });
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    final logVm   = context.read<LogViewModel>();
    final foodVm  = context.read<FoodIntakeViewModel>();
    final habitVm = context.read<DailyHabitViewModel>();

    final logDateStr = DateFormat('yyyy-MM-dd').format(logVm.selectedDate);

    final results = await Future.wait([
      _foodLog.saveDailyLog(
        foodCategories: foodVm.selectedFoodCategories,
        foodDetail:     foodVm.foodDetail,
        waterMl:        logVm.waterMl,
        logDate:        logDateStr,
      ),
      _symptomLog.saveSymptom(
        logVm.bodySignals,
        logDate: logDateStr,
      ),
      _habitLog.saveHabit(
        tidurMulai:   habitVm.tidurMulaiStr,
        tidurSelesai: habitVm.tidurSelesaiStr,
        durasiJam:    habitVm.durasiJam,
        logDate:      logDateStr,
        stresshigh:   habitVm.stresshigh,
        moderate:     habitVm.moderate,
        relaxed:      habitVm.relaxed,
        active:       habitVm.active,
        light:        habitVm.light,
        none:         habitVm.none,
      ),
      _apiService.submitDailyLog(
        logDate:        logDateStr,
        foodCategories: foodVm.selectedFoodCategories,
        foodDetail:     foodVm.foodDetail,
        signals:        logVm.bodySignals,
        durasiJam:      habitVm.durasiJam,
        waterMl:        logVm.waterMl,
        stresshigh:     habitVm.stresshigh,
        moderate:       habitVm.moderate,
        relaxed:        habitVm.relaxed,
        active:         habitVm.active,
        light:          habitVm.light,
        none:           habitVm.none,
      ),
    ]);

    setState(() => _isSaving = false);
    if (!mounted) return;

    final allSuccess = results.every((r) => r == true);

    if (allSuccess) {
      showDialog(context: context, builder: (_) => SavedPopupView());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sebagian gagal disimpan, coba lagi'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Consumer<LogViewModel>(
        builder: (context, vm, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: AppColors.pinkSoft,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                              icon: Icon(Icons.arrow_back_ios, color: AppColors.pinkMedium, size: 18.sp),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Today's Log",
                                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                              SizedBox(height: 4.h),
                              Text(vm.formattedDate,
                                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(color: AppColors.pinkSoft, shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () => vm.pickDate(context),
                            icon: Icon(Icons.calendar_today, color: AppColors.pinkMedium, size: 18.sp),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        FoodIntake(),
                        SizedBox(height: 15.h),
                        const WaterIntakeCard(),
                        SizedBox(height: 15.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                          ),
                          child: Column(
                            children: [
                              _buildHeader(),
                              SizedBox(height: 20.h),
                              ...bodySignalConfigs.map((data) => Padding(
                                padding: EdgeInsets.only(bottom: 15.h),
                                child: BodySignal(data['category'], data['labels'], data['images']),
                              )).toList(),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        DailyHabits(),
                        SizedBox(height: 20.h),
                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.pinkDark,
                              padding: EdgeInsets.symmetric(vertical: 18.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                              elevation: 0,
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text("Save",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.textWhite)),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildHeader() {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(10.w),
        decoration: const BoxDecoration(color: Color(0XFFFFECE7), shape: BoxShape.circle),
        child: Image.asset("assets/images/bodysignal.png"),
      ),
      SizedBox(width: 10.w),
      Text('Body Signal',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
    ],
  );
}