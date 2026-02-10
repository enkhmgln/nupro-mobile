import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/sign_forget_email_phone_controller.dart';
import 'package:get/get.dart';

class SignForgetEmailPhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignForgetEmailPhoneController());
  }
}
