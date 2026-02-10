import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TabBarScreen extends GetView<TabBarController> {
  static const routeName = '/TabBarScreen';
  const TabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IOScaffold(
        body: IndexedStack(
          index: controller.tabIndex.value,
          children: controller.tabItems.map((e) => e.screen).toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: IOColors.brand500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
          onPressed: controller.onTapQuestionnaire,
          child: SvgPicture.asset(
            'assets/icons/call-medicine-rounded-svgrepo-com.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              IOColors.backgroundPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
        bottomNavigationBar: TabBarWidget(
          items: controller.tabItems,
          currentIndex: controller.tabIndex.value,
          onChanged: controller.onTabChanged,
        ),
      ),
    );
  }
}
