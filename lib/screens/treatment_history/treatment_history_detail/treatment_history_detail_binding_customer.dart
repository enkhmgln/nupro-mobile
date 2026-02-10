import 'package:get/get.dart';
import 'package:nuPro/screens/home/model/treatment_model.dart';

class TreatmentHistoryDetailBindingCustomer extends Bindings {
  final TreatmentModel item;
  TreatmentHistoryDetailBindingCustomer(this.item);
  @override
  void dependencies() {
    // No controller needed for stateless customer detail screen
  }
}
