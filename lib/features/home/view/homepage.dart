import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:superraion/features/home/widget/insight_card.dart';
import 'package:superraion/features/home/widget/weekly_summary.dart';
import 'package:superraion/features/log/widget/recent_log.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/widgets/navbar.dart';
import '../../log/viewmodel/log_viewmodel.dart';
import '../model/home_model.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadFromFirestore();
      context.read<WeeklySummaryViewModel>().fetchWeeklyData();
      context.read<RecentLogViewModel>().loadRecentLog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final data = vm.homeData;

    if (data == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Padding(
          padding: EdgeInsets.only(bottom: 110.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 20.h),

              _buildHeader(vm),
              SizedBox(height: 21.h),
              _buildStreakCard(data),
              SizedBox(height: 24.h),
              RecentLogCard(),
              SizedBox(height: 24.h),
              InsightCard(),
              SizedBox(height: 24.h),
              WeeklySummaryCard()


            ],
          ),
        ),
      ),
       bottomNavigationBar: const MainNavbarView(),
    );
  }

  Widget _buildHeader(HomeViewModel vm) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(

        children: [
          Image.asset("assets/images/mascot.png", width: 80.w),
          SizedBox(width: 33.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(vm.todayDate, style: TextStyle(fontSize: 12.sp, color: Colors.grey[500], fontWeight: FontWeight.w500)),
              SizedBox(height: 4.h),
              Text("Hi, ${vm.homeData!.username}", style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
              Text("How are you today?", style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(HomeDataModel data) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nice Streak!", style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(20.r)),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department, color: const Color(0xFFF87171), size: 16.sp),
                    SizedBox(width: 4.w),
                    Text("${data.streakCount}-day streak", style: TextStyle(color: const Color(0xFFF87171), fontWeight: FontWeight.bold, fontSize: 13.sp)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("You've logged ${data.streakCount} days straight, keep going",
                style: TextStyle(color: Colors.grey[500], fontSize: 12.sp)),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data.weekStreak.map((day) => _buildDayItem(day)).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildDayItem(StreakDay day) {
    bool isToday = DateTime.now().day == day.date.day;

    return Column(
      children: [
        Text(day.dayName, style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
            color: isToday ? AppColors.pinkDark : Colors.grey[400]
        )),
        SizedBox(height: 8.h),
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: day.isLogged ? const Color(0xFFF87171) : const Color(0xFFF3F4F6),
            border: isToday && !day.isLogged
                ? Border.all(color: const Color(0xFFF87171), width: 2)
                : null,
          ),
          child: day.isLogged
              ? Center(child: Icon(Icons.circle, color: Colors.white, size: 8.sp)) // Inner circle style
              : (isToday ? Center(child: Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(color: Color(0xFFF87171), shape: BoxShape.circle))) : null),
        )
      ],
    );
  }
}