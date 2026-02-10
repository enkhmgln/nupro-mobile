import 'package:nuPro/screens/sign_in/sign_in_user/sign_in_user_controller.dart';
import 'package:get/get.dart';

class SignInUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInUserController());
  }
}
