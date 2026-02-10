import 'package:get/get.dart';
import 'package:nuPro/screens/home/model/nurse_treatment_model.dart';
import 'package:nuPro/screens/treatment_history/treaatment_nurse_history_detail/treaatment_nurse_history_detail_controller.dart';

class TreaatmentNurseHistoryDetailBinding extends Bindings {
  final NurseTreatmentModel item;
  TreaatmentNurseHistoryDetailBinding(this.item);
  @override
  void dependencies() {
    Get.lazyPut(() => TreatmentNurseHistoryDetailController(item: item));
  }
}
