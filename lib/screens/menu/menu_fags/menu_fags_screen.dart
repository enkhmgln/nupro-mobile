import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_empty.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/components/main/main.dart';
import 'package:nuPro/screens/menu/menu_fags/menu_fags_controller.dart';
import 'package:nuPro/screens/menu/menu_fags/widgets/fags_item_widget.dart';

class MenuFagsScreen extends GetView<MenuFagsController> {
  const MenuFagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(titleText: 'Түгээмэл асуулт хариулт'),
      body: Obx(
        () => controller.faq.isEmpty
            ? const IOEmptyWidget(
                text: 'Хоосон байна.',
                icon: 'empty.background.svg',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  final item = controller.faq[index];
                  return FagsItemWidget(model: item);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
                itemCount: controller.faq.length,
              ),
      ),
    );
  }
}
