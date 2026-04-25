import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodel/log_viewmodel.dart';

class DailyHabits extends StatelessWidget {
  const DailyHabits({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyHabitViewModel>();

    return Container(
      width: 350.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 24.h),
          _sectionTitle("Sleep Schedule"),
          SizedBox(height: 12.h),
          _buildSleepPickers(vm, context),
          SizedBox(height: 10.h),
          _buildCategory("Stress", ["Relaxed", "Moderate", "High"], ["assets/images/stressrelax.png", "assets/images/stressmoderate.png", "assets/images/stresshigh.png"], vm.habit.stressIndex, vm.setStress, vm),
          SizedBox(height: 10.h),
          _buildCategory("Exercise", ["Active", "Light", "None"], ["assets/images/exactive.png", "assets/images/exlight.png", "assets/images/exnone.png"], vm.habit.exerciseIndex, vm.setExercise, vm),
          SizedBox(height: 10.h),
          _buildCategory("Caffeine & Alcohol", ["None", "Low", "High"], ["assets/images/caffeinnone.png", "assets/images/caffeinelow.png", "assets/images/caffeinhigh.png"], vm.habit.caffeineIndex, vm.setCaffeine, vm),

        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          CircleAvatar(radius: 18.r, backgroundColor: const Color(0xFFF0EEF9), child: Image.asset("assets/images/dailyhabbit.png")),
          SizedBox(width: 10.w),
          Text("Daily Habits", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        ]),
        Text("Optional", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSleepPickers(DailyHabitViewModel vm, BuildContext context) {
    return Row(children: [
      _timeCard("Sleep time", vm.habit.sleepTime.format(context), () => vm.selectTime(context, true)),
      SizedBox(width: 12.w),
      _timeCard("Wake up time", vm.habit.wakeUpTime.format(context), () => vm.selectTime(context, false)),
    ]);
  }

  Widget _timeCard(String title, String time, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          decoration: BoxDecoration(color: const Color(0xFFF3F4F6).withOpacity(0.5), borderRadius: BorderRadius.circular(16.r)),
          child: Column(children: [
            Text(title, style: TextStyle(fontSize: 10.sp, color: Colors.grey[600])),
            SizedBox(height: 4.h),
            Text(time, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: const Color(0xFF4C66CD))),
          ]),
        ),
      ),
    );
  }

  Widget _buildCategory(String title, List<String> labels, List<String> icons, int? selected, Function(int) onSelect, DailyHabitViewModel vm) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle(title),
      SizedBox(height: 12.h),
      Row(children: List.generate(3, (i) {
        bool isSelected = selected == i;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: vm.getBgColor(i, isSelected),
                borderRadius: BorderRadius.circular(12.r),
                // border: Border.all(color: isSelected ? vm.getTextColor(i, true) : const Color(0xFFE5E7EB)),
              ),
              child: Column(children: [
                Image.asset("${icons[i]}", width: 32.w, height: 32.h),
                SizedBox(height: 8.h),
                Text(labels[i], style: TextStyle(fontSize: 11.sp, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: vm.getTextColor(i, isSelected))),
              ]),
            ),
          ),
        );
      })),
    ]);
  }

  Widget _sectionTitle(String t) => Text(t, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600));

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF87171), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)), padding: EdgeInsets.symmetric(vertical: 14.h), elevation: 0),
        child: Text("Save Log", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }
}