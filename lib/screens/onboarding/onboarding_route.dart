import 'package:get/get.dart';
import 'package:nuPro/screens/onboarding/onboarding_binding.dart';
import 'package:nuPro/screens/onboarding/onboarding_screen.dart';

class OnboardingRoute {
  static toOnboarding() {
    Get.to(
      () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    );
  }
}
