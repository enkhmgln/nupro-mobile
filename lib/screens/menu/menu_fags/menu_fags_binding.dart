import 'package:get/get.dart';
import 'package:nuPro/screens/menu/menu_fags/menu_fags_controller.dart';

class MenuFagsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuFagsController());
  }
}
