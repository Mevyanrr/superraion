import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_color.dart';
import '../viewmodel/log_viewmodel.dart';
import 'card_signal.dart';

class BodySignal extends StatelessWidget {
  final String category;
  final List<String> labels;
  final List<String> images;

  const BodySignal(this.category, this.labels, this.images);

  Color getBgColor(int index) {
    switch (index) {
      case 0: return const Color(0xFFE7F4EC); // Green
      case 1: return const Color(0xFFFFF8E2); // Yellow
      case 2: return const Color(0xFFF9E4E7); // Red
      default: return Colors.grey;
    }
  }

  Color getTextColor(int index) {
    switch (index) {
      case 0: return const Color(0xFF2E7D32); // GreenText
      case 1: return const Color(0xFFF9A825); // YellowText
      case 2: return const Color(0xFFC62828); // RedText
      default: return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogViewModel>(
      builder: (context, vm, _) {
        final selected = vm.getSelectedIndex(category);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
                category,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: SignalCard(
                      label: labels[index],
                      imagePath: images[index],
                      isSelected: selected == index,
                      activeBgColor: getBgColor(index),
                      activeTextColor: getTextColor(index),
                      onTap: () => vm.selectOption(category, index),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }
}

