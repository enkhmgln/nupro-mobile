import 'package:get/get.dart';
import 'package:nuPro/screens/menu/my_ratings/my_ratings_controller.dart';

class MyRatingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyRatingsController());
  }
}
