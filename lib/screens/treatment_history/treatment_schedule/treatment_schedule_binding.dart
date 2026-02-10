import 'package:nuPro/screens/treatment_history/treatment_schedule/treatment_schedule_controller.dart';
import 'package:get/get.dart';

class TreatmentScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TreatmentScheduleController());
  }
}
