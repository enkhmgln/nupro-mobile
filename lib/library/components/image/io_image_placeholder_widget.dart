import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IOImagePlaceholderWidget extends StatelessWidget {
  final Widget? icon;
  final double iconSize;
  final Color? backgroundColor;

  const IOImagePlaceholderWidget({
    super.key,
    this.icon,
    this.iconSize = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: backgroundColor ?? const Color(0xFFEEF2F6),
      child: SizedBox.square(
        dimension: iconSize,
        child: icon ??
            SvgPicture.asset(
              'assets/icons/placeholder.svg',
            ),
      ),
    );
  }
}
