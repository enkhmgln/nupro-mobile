import 'package:get/get.dart';
import 'package:nuPro/screens/customer_call_map/customer_call_map_rating/customer_call_map_rating_controller.dart';

class CustomerCallMapRatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerCallMapRatingController());
  }
}
