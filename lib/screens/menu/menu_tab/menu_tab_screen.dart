import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/menu/menu_tab/menu_tab_controller.dart';
import 'package:nuPro/screens/menu/menu_tab/widgets/menu_profile_widget.dart';
import 'package:nuPro/screens/menu/menu_tab/widgets/menu_tab_widget.dart';

class MenuTabScreen extends StatelessWidget {
  final controller = Get.put(MenuTabController());
  MenuTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IOScaffold(
        appBar: IOAppBar(
          titleText: 'Тохиргоо',
        ),
        body: controller.isInitialLoading.value
            ? const IOLoading()
            : SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 24 + 36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Хэрэглэгчийн мэдээлэл",
                      style: IOStyles.body1Bold.copyWith(
                        color: IOColors.brand700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MenuProfileWidget(
                      user: controller.profileInfo.value,
                      onTap: controller.onTapProfile,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final model = controller.items[index];
                        return MenuTabWidget(
                          model: model,
                          onTap: controller.onTapItem,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 16);
                      },
                      itemCount: controller.items.length,
                    ),
                    const SizedBox(height: 16),
                    // IOButtonWidget(
                    //   model: controller.logoutButton,
                    //   onPressed: controller.onTapLogout,
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}
