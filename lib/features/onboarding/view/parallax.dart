import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/onboarding_viewmodel.dart';

class ParallaxImageLayer extends StatelessWidget {
  const ParallaxImageLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

    return Stack(
      children: vm.items.asMap().entries.map((entry) {
        int index = entry.key;

        double diff = index - vm.scrollOffset;
        double opacity = (1 - diff.abs()).clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: SizedBox.expand(
            child: Image.asset(
              entry.value.imagePath,
              fit: BoxFit.fitHeight,

              alignment: Alignment(lerpDouble(-1.0, 1.0, vm.autoScrollValue)!, 0),
            ),
          ),
        );
      }).toList(),
    );
  }

  double? lerpDouble(num a, num b, double t) => a + (b - a) * t;
}