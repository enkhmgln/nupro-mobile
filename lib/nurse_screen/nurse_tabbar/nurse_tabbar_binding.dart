import 'package:get/get.dart';
import 'package:nuPro/nurse_screen/nurse_home/nurse_home.dart';
import 'package:nuPro/nurse_screen/nurse_tabbar/nurse_tabbar_controller.dart';
import 'package:nuPro/screens/menu/menu_tab/menu_tab_controller.dart';
import 'package:nuPro/screens/notification/notification_list/notification_list_controller.dart';
import 'package:nuPro/screens/treatment_history/treatment_schedule/treatment_schedule_controller.dart';

class NurseTabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NurseTabbarController());
    Get.lazyPut(() => NurseHomeController());
    Get.lazyPut(() => NotificationListController());
    Get.lazyPut(() => MenuTabController());
    Get.lazyPut(() => TreatmentScheduleController());
  }
}
