import 'package:nuPro/screens/sign_forget/sign_forget_field/sign_forget_field_controller.dart';
import 'package:get/get.dart';

class SignForgetFieldBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignForgetFieldController());
  }
}
