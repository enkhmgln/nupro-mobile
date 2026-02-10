import 'package:get/instance_manager.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_user_type/sign_up_user_type_controller.dart';

class SignUpUserTypeBinding extends Bindings {
  final SignUpModel model;
  SignUpUserTypeBinding({
    required this.model,
  });
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpUserTypeController(model: model));
  }
}
