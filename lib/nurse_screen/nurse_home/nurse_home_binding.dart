import 'package:get/instance_manager.dart';
import 'package:nuPro/nurse_screen/nurse_home/nurse_home_controller.dart';

class NurseHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NurseHomeController());
  }
}
