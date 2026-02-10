import 'package:nuPro/screens/sign_up/sign_up_phone/sign_up_phone_controller.dart';
import 'package:get/get.dart';

class SignUpPhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpPhoneController());
  }
}
