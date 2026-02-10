import 'package:nuPro/screens/sign_up/sign_up_info/sign_up_info_controller.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:get/get.dart';

class SignUpInfoBinding extends Bindings {
  final SignUpModel model;

  SignUpInfoBinding({
    required this.model,
  });
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpInfoController(model: model));
  }
}
