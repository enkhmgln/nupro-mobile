import 'package:nuPro/screens/sign_up/sign_up_pass/sign_up_pass_controller.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:get/get.dart';

class SignUpPassBinding extends Bindings {
  final SignUpModel model;

  SignUpPassBinding({
    required this.model,
  });
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpPassController(model: model));
  }
}
