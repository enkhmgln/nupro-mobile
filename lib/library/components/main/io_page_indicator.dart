import 'package:flutter/material.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IOPageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;
  const IOPageIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: const ScrollingDotsEffect(
        dotHeight: 8,
        dotWidth: 24,
        spacing: 8,
        radius: 2,
        activeDotColor: IOColors.brand500,
        dotColor: IOColors.brand100,
        maxVisibleDots: 7,
      ),
    );
  }
}
