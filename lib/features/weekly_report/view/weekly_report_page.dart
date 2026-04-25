import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superraion/features/weekly_report/viewmodel/weekly_report.dart';
import 'package:superraion/features/weekly_report/widget/medical_note.dart';

import '../../../core/constants/app_color.dart';
import '../../home/viewmodel/home_viewmodel.dart';
import '../../home/widget/weekly_summary.dart';
import '../widget/body_story_card.dart';
import '../widget/custom_appbar.dart';
import '../widget/expert_insight_card.dart';
import '../widget/most_consumed_section.dart';
import '../widget/tips_next_week_card.dart';

class WeeklyReportPage extends StatefulWidget {
  const WeeklyReportPage({super.key});

  @override
  State<WeeklyReportPage> createState() => _WeeklyReportPageState();
}

class _WeeklyReportPageState extends State<WeeklyReportPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BodyInsightViewModel>().fetchAIInsights();
      context.read<WeeklyAnalysisViewModel>().fetchWeeklyAnalysis();
      context.read<MedicalNoteViewModel>().fetchMedicalNote();
      context.read<WeeklySummaryViewModel>().fetchWeeklyData();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: WeeklyAppBar(),
      body: Consumer2<BodyInsightViewModel, WeeklyAnalysisViewModel>(
        builder: (context, bodyVm, weeklyVm, child) {
          if (bodyVm.insights.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF87171),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                const BodyStoryCard(),
                SizedBox(height: 20.h),

                MedicalNoteCard(),
                SizedBox(height: 20.h),

                WeeklySummaryCard(),
                SizedBox(height: 20.h),

                buildMostConsumed(weeklyVm),
                SizedBox(height: 20.h),

                buildExpertInsight(),
                SizedBox(height: 20.h),

                buildTipsSection(weeklyVm),
              ],
            ),
          );
        },
      ),
    );
  }
}