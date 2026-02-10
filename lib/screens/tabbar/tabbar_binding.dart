import 'package:nuPro/screens/screens.dart';
import 'package:get/get.dart';

class TabBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabBarController());
    Get.lazyPut(() => NotificationListController());
    Get.lazyPut(() => MenuTabController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => TreatmentScheduleController());
  }
}
