import 'package:get/get.dart';
import 'package:nuPro/screens/home/home_call_google_map/home_call_google_map_controller.dart';
import 'package:nuPro/screens/home/home_questionnaire/model/health_info_model.dart';

class HomeCallGoogleMapBinding extends Bindings {
  final HealthInfoModel healthInfo;
  final List<NearestNursesModel> nearestNurses;

  HomeCallGoogleMapBinding({
    required this.healthInfo,
    required this.nearestNurses,
  });
  @override
  void dependencies() {
    Get.lazyPut(() => HomeCallGoogleMapController(
          healthInfo: healthInfo,
          nearestNurses: nearestNurses,
        ));
  }
}
