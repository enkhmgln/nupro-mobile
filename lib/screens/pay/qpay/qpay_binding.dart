import 'package:get/get.dart';
import 'package:nuPro/screens/pay/qpay/models/qpay_screen_model.dart';
import 'package:nuPro/screens/pay/qpay/qpay_controller.dart';

class QpayBinding extends Bindings {
  final QpayScreenModel model;
  QpayBinding({required this.model});
  @override
  void dependencies() {
    Get.lazyPut(() => QpayController(model: model));
  }
}
