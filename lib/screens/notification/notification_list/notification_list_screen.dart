import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_empty.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/main/io_refresher%20copy.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/screens/notification/notification_list/notification_list_controller.dart';
import 'package:nuPro/screens/notification/notification_list/widgets/notificatoin_list_item_widget.dart';

class NotificationListScreen extends GetView<NotificationListController> {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Мэдэгдэл',
      ),
      body: Obx(
        () => controller.isInitialLoading.value
            ? const IOLoading()
            : IORefresher(
                controller: controller.refreshController,
                enablePullDown: true,
                onRefresh: controller.onRefresh,
                child: controller.notificationItems.isEmpty
                    ? const IOEmptyWidget(
                        icon: 'notification.svg',
                        text: 'Танд мэдэгдэл ирээгүй байна',
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        children: controller.notificationItems
                            .map((e) => NotificatoinListItemWidget(
                                  item: e,
                                  onTap: () => controller.onTapItem(e),
                                ))
                            .toList(),
                      ),
              ),
      ),
    );
  }
}
