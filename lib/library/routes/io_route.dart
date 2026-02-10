import 'package:nuPro/screens/sign_in/sign_in_user/sign_in_user.dart';
import 'package:get/get.dart';

class IORoute {
  static toSignInScreen() {
    Get.off(
      () => SignInUserScreen(),
      binding: SignInUserBinding(),
    );
  }
}
