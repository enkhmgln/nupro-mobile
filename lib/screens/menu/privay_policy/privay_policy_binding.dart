import 'package:get/get.dart';
import 'package:nuPro/screens/menu/privay_policy/privay_policy_controller.dart';

class PrivayPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivayPolicyController());
  }
}
