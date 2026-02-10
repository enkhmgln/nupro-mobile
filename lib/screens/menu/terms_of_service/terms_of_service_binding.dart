import 'package:get/get.dart';
import 'package:nuPro/screens/menu/terms_of_service/terms_of_service_controller.dart';

class TermsOfServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TermsOfServiceController());
  }
}
