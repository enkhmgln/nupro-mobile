import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/models/sign_reset_model.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_pass/sign_forget_pass_controller.dart';
import 'package:get/get.dart';

class SignForgetPassBinding extends Bindings {
  final SignResetModel model;

  SignForgetPassBinding({
    required this.model,
  });

  @override
  void dependencies() {
    Get.lazyPut(() => SignForgetPassController(model: model));
  }
}
