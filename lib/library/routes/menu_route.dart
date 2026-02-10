import 'package:get/get.dart';
import 'package:nuPro/screens/menu/contact/contact.dart';
import 'package:nuPro/screens/menu/menu_fags/menu_fags_binding.dart';
import 'package:nuPro/screens/menu/menu_fags/menu_fags_screen.dart';
import 'package:nuPro/screens/menu/menu_info/menu_info_binding.dart';
import 'package:nuPro/screens/menu/menu_info/menu_info_screen.dart';
import 'package:nuPro/screens/menu/my_ratings/my_ratings_binding.dart';
import 'package:nuPro/screens/menu/my_ratings/my_ratings_screen.dart';
import 'package:nuPro/screens/menu/nurse_ratings/nurse_ratings_binding.dart';
import 'package:nuPro/screens/menu/nurse_ratings/nurse_ratings_screen.dart';
import 'package:nuPro/screens/menu/privay_policy/privay_policy_binding.dart';
import 'package:nuPro/screens/menu/privay_policy/privay_policy_screen.dart';
import 'package:nuPro/screens/menu/terms_of_service/terms_of_service_binding.dart';
import 'package:nuPro/screens/menu/terms_of_service/terms_of_service_screen.dart';

class MenuRoute {
  static toFaq() {
    Get.to(
      () => const MenuFagsScreen(),
      binding: MenuFagsBinding(),
    );
  }

  static toMenuInfo() {
    Get.to(
      () => const MenuInfoScreen(),
      binding: MenuInfoBinding(),
    );
  }

  static toContact() {
    Get.to(
      () => const ContactScreen(),
      binding: ContactBinding(),
    );
  }

  static toTermsOfService() {
    Get.to(
      () => const TermsOfServiceScreen(),
      binding: TermsOfServiceBinding(),
    );
  }

  static toPrivayPolicy() {
    Get.to(
      () => const PrivayPolicyScreen(),
      binding: PrivayPolicyBinding(),
    );
  }

  static toMyRatings() {
    Get.to(
      () => const MyRatingsScreen(),
      binding: MyRatingsBinding(),
    );
  }

  static toRatingNurse({required int nurseId}) {
    Get.to(
      () => const NurseRatingsScreen(),
      binding: NurseRatingsBinding(nurseId: nurseId),
    );
  }
}
