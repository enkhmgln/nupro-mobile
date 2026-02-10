import 'package:get/get.dart';
import 'package:nuPro/library/client/models/call_detail_info.dart';
import 'package:nuPro/nurse_screen/nurse_call_google_map/nurse_call_google_map_controller.dart';

class NurseCallGoogleMapBinding extends Bindings {
  final CallDetailInfoModel callDetailInfoModel;

  NurseCallGoogleMapBinding({
    required this.callDetailInfoModel,
  });
  @override
  void dependencies() {
    Get.lazyPut(() =>
        NurseCallGoogleMapController(callDetailInfoModel: callDetailInfoModel));
  }
}
