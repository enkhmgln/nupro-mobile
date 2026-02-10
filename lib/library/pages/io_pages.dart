import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:nuPro/nurse_screen/nurse_tabbar/nurse_tabbar.dart';
import 'package:nuPro/screens/onboarding/onboarding_binding.dart';
import 'package:nuPro/screens/onboarding/onboarding_screen.dart';
import 'package:nuPro/screens/sign_in/sign_in_user/sign_in_user_binding.dart';
import 'package:nuPro/screens/sign_in/sign_in_user/sign_in_user_screen.dart';
import 'package:nuPro/screens/splash/splash_binding.dart';
import 'package:nuPro/screens/splash/splash_screen.dart';
import 'package:nuPro/screens/tabbar/tabbar_binding.dart';
import 'package:nuPro/screens/tabbar/tabbar_screen.dart';
import 'package:get/get.dart';

class IOPages {
  static String get initial => !HelperManager.isOnboardingCompleted
      ? OnboardingScreen.routeName
      : !HelperManager.isLogged
          ? SignInUserScreen.routeName
          : (HelperManager.profileInfo.userType == 'nurse'
              ? NurseTabbarScreen.routeName
              : TabBarScreen.routeName);

  static String get splash => SplashScreen.routeName;

  static final pages = [
    GetPage(
      name: SplashScreen.routeName,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: SignInUserScreen.routeName,
      page: () => SignInUserScreen(),
      binding: SignInUserBinding(),
    ),
    GetPage(
      name: OnboardingScreen.routeName,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: TabBarScreen.routeName,
      page: () => const TabBarScreen(),
      binding: TabBarBinding(),
    ),
    GetPage(
      name: NurseTabbarScreen.routeName,
      page: () => const NurseTabbarScreen(),
      binding: NurseTabbarBinding(),
    ),
  ];

  static toInitial() {
    Get.offAllNamed(initial);
  }

  static toHome() {
    Get.offAllNamed(TabBarScreen.routeName);
  }

  static toNurse() {
    Get.offAllNamed(NurseTabbarScreen.routeName);
  }

  static toOnboarding() {
    Get.offAllNamed(OnboardingScreen.routeName);
  }
}
