import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/weekly_report.dart';
import '../viewmodel/weekly_report.dart';

class BodyStoryCard extends StatelessWidget {
  const BodyStoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Body Tells a Story",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(18.w), // Padding sesuai Figma
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "We've spotted patterns in your body, cycles, and daily habits this week.",
                style: TextStyle(fontSize: 18.sp, color: const Color(0xFF1F2937)),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB), // Grey background AI area
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Consumer<BodyInsightViewModel>(
                  builder: (context, vm, _) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vm.insights.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h), // Gap 10px-12px
                      itemBuilder: (context, index) {
                        return _buildInsightRow(vm.insights[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightRow(BodyInsightItem item) {
    final bool isWarning = item.type == InsightType.warning;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isWarning ? Icons.error_outline_rounded : Icons.info_outline_rounded,
          color: isWarning ? const Color(0xFFF87171) : const Color(0xFF60A5FA),
          size: 24.sp,
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: RichText(
            text: _parseStyledText(item.text),
          ),
        ),
      ],
    );
  }

  TextSpan _parseStyledText(String text) {
    final List<TextSpan> children = [];
    final RegExp regExp = RegExp(r'\*(.*?)\*');
    int start = 0;

    for (final Match match in regExp.allMatches(text)) {
      if (match.start > start) {
        children.add(TextSpan(text: text.substring(start, match.start)));
      }
      children.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      start = match.end;
    }

    if (start < text.length) {
      children.add(TextSpan(text: text.substring(start)));
    }

    return TextSpan(
      style: TextStyle(fontSize: 16.sp, color: const Color(0xFF374151), height: 1.4),
      children: children,
    );
  }
}