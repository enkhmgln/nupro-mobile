import 'package:get/get.dart';
import 'package:nuPro/screens/home/home_form_page/home_form_page_controller.dart';
import 'package:nuPro/screens/home/home_questionnaire/home_questionnaire_controller.dart';

class HomeFormPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeFormPageController());
    Get.lazyPut(() => HomeQuestionnaireController());
  }
}
