import 'package:get/get.dart';
import 'package:nuPro/screens/home/home_to_call_form/home_to_call_form_controller.dart';

class HomeToCallFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeToCallFormController());
  }
}
