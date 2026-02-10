import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/models/sign_reset_model.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_otp/sign_forget_otp_controller.dart';
import 'package:get/get.dart';

class SignForgetOtpBinding extends Bindings {
  final SignResetModel model;

  SignForgetOtpBinding({
    required this.model,
  });

  @override
  void dependencies() {
    Get.lazyPut(() => SignForgetOtpController(model: model));
  }
}
