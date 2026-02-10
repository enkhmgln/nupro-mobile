import 'package:nuPro/library/pages/io_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final opacity = 0.0.obs;

  @override
  void onReady() {
    super.onReady();
    opacity.value = 1;
  }

  void navigateToLogin() {
    // Get.toNamed(SignInMainScreen.routeName);

    // Get.offAllNamed(IOPages.initial);
    Get.offAllNamed(IOPages.initial);

    // Future.delayed(const Duration(seconds: 3)).then((_) {
    //   Navigator.pushReplacementNamed(context, SignInUserScreen.routeName);
    // });
  }
}
