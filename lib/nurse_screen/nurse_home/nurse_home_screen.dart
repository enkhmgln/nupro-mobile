import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:nuPro/library/components/main/io_empty.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/main/io_refresher.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/components/widgets/treatment_card_widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/nurse_screen/nurse_home/nurse_home_controller.dart';
import 'package:nuPro/screens/home/widgets/home_banner_widget.dart';
import 'package:nuPro/screens/home/widgets/home_call_widget.dart';
import 'package:nuPro/screens/home/widgets/home_custom_appbar_widget.dart';

class NurseHomeScreen extends GetView<NurseHomeController> {
  const NurseHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IOScaffold(
        body: IORefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          onRefresh: controller.getData,
          child: CustomScrollView(
            slivers: [
              HomeCustomAppbarWidget(
                onTapProfile: controller.onTapProfile,
                calling: Obx(() => HomeCallWidget(
                      toggleCall: controller.toggleCall,
                      profileInfo: controller.profileInfo.value,
                      callStatusLabel: controller.callStatusLabel.value,
                    )),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                  child: HomeBannerWidget(
                    items: controller.bannerItems.toList(),
                  ),
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Миний үйлчилгээний түүх',
                        style: IOStyles.body1Bold.copyWith(
                          color: IOColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Бүгдийг харах',
                        style: IOStyles.body1Bold.copyWith(
                          color: IOColors.brand500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: Obx(() {
                  final history = controller.history;
                  final isLoading = controller.isLoading.value;

                  if (isLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(child: IOLoading()),
                    );
                  } else if (history.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: IOEmptyWidget(
                          text: 'Түүх олдсонгүй',
                          icon: 'history-svgrepo-com.svg',
                        ),
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: history.map((item) {
                          return GestureDetector(
                            onTap: () {
                              print('Tapped history item: ${item.runtimeType}');
                              controller.toTreatmentHistoryDetail(item);
                            },
                            child: TreatmentCardWidget.nurse(item: item),
                          );
                        }).toList(),
                      ),
                    );
                  }
                }),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
