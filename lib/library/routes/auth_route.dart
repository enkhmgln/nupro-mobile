import 'package:nuPro/screens/notification/notification_list/notification_list_binding.dart';
import 'package:nuPro/screens/notification/notification_list/notification_list_screen.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/models/sign_reset_model.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/sign_forget_email_phone_binding.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/sign_forget_email_phone_controller.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/sign_forget_email_phone_screen.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_field/sign_forget_field_binding.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_field/sign_forget_field_screen.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_otp/sign_forget_otp_binding.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_otp/sign_forget_otp_screen.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_pass/sign_forget_pass_binding.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_pass/sign_forget_pass_screen.dart';
import 'package:nuPro/screens/sign_in/sign_in_user/sign_in_user_binding.dart';
import 'package:nuPro/screens/sign_in/sign_in_user/sign_in_user_screen.dart';
import 'package:nuPro/screens/sign_up/sign_up.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_user_type/sign_up_user_type_binding.dart';
import 'package:nuPro/screens/sign_up/sign_up_user_type/sign_up_user_type_screen.dart';
import 'package:nuPro/screens/tabbar/tabbar.dart';
import 'package:get/get.dart';

class AuthRoute {
  static toTabBar() {
    Get.offAll(
      () => const TabBarScreen(),
      binding: TabBarBinding(),
    );
  }

  static toSignInScreen() {
    Get.offAll(
      () => SignInUserScreen(),
      binding: SignInUserBinding(),
    );
  }

  static toForgetPass() {
    Get.to(
      () => const SignForgetEmailPhoneScreen(),
      binding: SignForgetEmailPhoneBinding(),
    );
  }

  static toForgetField(ForgetType type) {
    Get.to(
      () => SignForgetFieldScreen(type: type),
      binding: SignForgetFieldBinding(),
    );
  }

  static toForgetOtp({required SignResetModel model}) {
    Get.to(
      () => const SignForgetOtpScreen(),
      binding: SignForgetOtpBinding(model: model),
    );
  }

  static toOtpForgetCheck({required SignResetModel model}) {
    Get.to(
      () => const SignForgetPassScreen(),
      binding: SignForgetPassBinding(model: model),
    );
  }

  static toSignUpScreen() {
    Get.to(
      () => const SignUpPhoneScreen(),
      binding: SignUpPhoneBinding(),
    );
  }

  static toSignUpOtp(SignUpModel model) {
    Get.to(
      () => const SignUpOtpScreen(),
      binding: SignUpOtpBinding(model: model),
    );
  }

  static toSignUpInfo(SignUpModel model) {
    Get.to(
      () => const SignUpInfoScreen(),
      binding: SignUpInfoBinding(model: model),
    );
  }

  static toSignUpUserType(SignUpModel model) {
    Get.to(
      () => const SignUpUserTypeScreen(),
      binding: SignUpUserTypeBinding(model: model),
    );
  }

  static toSignUpPass(SignUpModel model) {
    Get.to(
      () => const SignUpPassScreen(),
      binding: SignUpPassBinding(model: model),
    );
  }

  static toNification() {
    Get.to(
      () => const NotificationListScreen(),
      binding: NotificationListBinding(),
    );
  }
}
