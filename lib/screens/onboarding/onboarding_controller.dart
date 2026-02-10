import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/shared/store_manager.dart';
import 'package:nuPro/library/utils/constants.dart';
import 'package:nuPro/screens/onboarding/models/onboarding_model.dart';
import 'package:nuPro/screens/sign_in/sign_in_user/sign_in_user_screen.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final currentPage = 0.obs;
  final onboardingPages = OnboardingData.onboardingPages;


  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() async {
    // Mark onboarding as completed
    await DeviceStoreManager.shared.write(kOnboardingCompleted, true);

    // Navigate to sign in screen
    Get.offAllNamed(SignInUserScreen.routeName);
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
