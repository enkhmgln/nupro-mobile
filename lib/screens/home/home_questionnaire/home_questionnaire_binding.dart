import 'package:get/get.dart';
import 'package:nuPro/screens/home/home_questionnaire/home_questionnaire_controller.dart';

class HomeQuestionnaireBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeQuestionnaireController>()) {
      Get.put(HomeQuestionnaireController(), permanent: true);
    }
  }
}
