import 'package:nuPro/library/theme/io_colors.dart';
import 'package:flutter/widgets.dart';

class IOBottomNavigationBar extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const IOBottomNavigationBar({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? IOColors.backgroundSecondary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
