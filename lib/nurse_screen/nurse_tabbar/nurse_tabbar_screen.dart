import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/nurse_screen/nurse_tabbar/nurse_tabbar_controller.dart';
import 'package:nuPro/nurse_screen/nurse_tabbar/widget/nurse_tabbar_appbar_widget.dart';

class NurseTabbarScreen extends GetView<NurseTabbarController> {
  static const String routeName = '/nurseTabbar';

  const NurseTabbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IOScaffold(
        body: IndexedStack(
          index: controller.tabIndex.value,
          children: controller.tabItems.map((e) => e.screen).toList(),
        ),
        bottomNavigationBar: NurseTabbarAppbarWidget(
          items: controller.tabItems,
          currentIndex: controller.tabIndex.value,
          onChanged: controller.onTabChanged,
        ),
      ),
    );
  }
}
