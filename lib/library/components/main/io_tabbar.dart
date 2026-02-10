import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_shadow.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:flutter/material.dart';

class IOTabBar extends StatelessWidget {
  final List<String> tabs;
  const IOTabBar({
    super.key,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: IOColors.strokePrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: IOColors.backgroundPrimary,
          boxShadow: IOShadow.primary2,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(2),
        dividerHeight: 0,
        labelStyle: IOStyles.body2Bold,
        unselectedLabelStyle: IOStyles.body2Bold.copyWith(
          color: IOColors.textTertiary,
        ),
        tabs: tabs
            .map(
              (e) => Tab(
                text: e,
              ),
            )
            .toList(),
      ),
    );
  }
}
