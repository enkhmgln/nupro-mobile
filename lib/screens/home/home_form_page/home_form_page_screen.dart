import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:nuPro/library/components/main/io_page_indicator.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/screens/home/home_form_page/home_form_page_controller.dart';

class HomeFormPageScreen extends GetView<HomeFormPageController> {
  const HomeFormPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Асуумж',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: IOPageIndicator(
              controller: controller.pageController,
              count: controller.screens.length,
            ),
          ),
        ],
      ),
    );
  }
}
