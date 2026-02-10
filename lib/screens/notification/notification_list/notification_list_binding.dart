import 'package:get/get.dart';
import 'package:nuPro/screens/notification/notification_list/notification_list_controller.dart';

class NotificationListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationListController());
  }
}
