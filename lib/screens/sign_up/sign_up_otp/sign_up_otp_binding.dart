import 'package:nuPro/screens/sign_up/sign_up_otp/sign_up_otp_controller.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:get/get.dart';

class SignUpOtpBinding extends Bindings {
  final SignUpModel model;
  SignUpOtpBinding({
    required this.model,
  });
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpOtpController(model: model));
  }
}
