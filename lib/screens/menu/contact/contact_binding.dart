import 'package:get/get.dart';
import 'package:nuPro/screens/menu/contact/contact_controller.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactController());
  }
}
