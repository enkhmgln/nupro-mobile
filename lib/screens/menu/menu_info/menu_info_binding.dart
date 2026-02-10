import 'package:get/get.dart';
import 'package:nuPro/screens/menu/menu_info/menu_info_controller.dart';

class MenuInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuInfoController());
  }
}
