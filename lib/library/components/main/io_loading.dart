import 'package:flutter/material.dart';
import 'package:nuPro/library/theme/io_colors.dart';

class IOLoading extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  const IOLoading({
    super.key,
    this.size = 30,
    this.strokeWidth = 2,
    this.color = IOColors.brand500,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: size,
        // child: LottieBuilder.asset(
        //   'assets/json/loading.json',
        //   repeat: true,
        //   fit: BoxFit.contain,
        // ),

        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(color),
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
