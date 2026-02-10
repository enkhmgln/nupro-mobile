import 'package:get/get.dart';
import 'package:nuPro/screens/menu/nurse_ratings/nurse_ratings_controller.dart';

class NurseRatingsBinding extends Bindings {
  final int nurseId;
  NurseRatingsBinding({required this.nurseId});
  @override
  void dependencies() {
    Get.lazyPut(() => NurseRatingsController(nurseId: nurseId));
  }
}
