import 'package:nuPro/library/theme/io_colors.dart';
import 'package:flutter/material.dart';

class IOCardBorderWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  const IOCardBorderWidget({
    super.key,
    required this.child,
    this.padding,
    this.alignment,
    this.borderRadius,
    this.border,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor ?? IOColors.backgroundPrimary,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: borderColor ?? IOColors.strokePrimary,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
