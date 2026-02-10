import 'package:get/get.dart';
import 'package:nuPro/library/client/models/call_detail_info.dart';
import 'package:nuPro/screens/customer_call_map/customer_call_map_controller.dart';

class CustomerCallMapBinding extends Bindings {
  final CallDetailInfoModel callDetailInfoModel;

  CustomerCallMapBinding({
    required this.callDetailInfoModel,
  });

  @override
  void dependencies() {
    Get.lazyPut<CustomerCallMapController>(
      () => CustomerCallMapController(
        callDetailInfoModel: callDetailInfoModel,
      ),
    );
  }
}
