import 'package:flutter/material.dart';
import 'package:nuPro/library/components/main/io_controller.dart';
import 'package:nuPro/library/routes/home_route.dart';
import 'package:nuPro/screens/home/model/treatment_model.dart';
import 'package:nuPro/screens/home/model/nurse_treatment_model.dart';
import 'package:nuPro/library/client/api/customer_api.dart';
import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:get/get.dart';

class TreatmentScheduleController extends IOController {
  var history = <dynamic>[].obs;
  @override
  var isLoading = false.obs;

  var selectedStatus = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    getTreatmentHistory();
  }

  Future<void> getTreatmentHistory({
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    isLoading.value = true;
    final response = await CustomerApi().getTreatment(
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
    if (response.isSuccess) {
      final userType = HelperManager.profileInfo.userType;
      if (userType == 'nurse') {
        history.value = response.data.listValue
            .map((e) => NurseTreatmentModel.fromJson(e))
            .toList();
      } else {
        history.value = response.data.listValue
            .map((e) => TreatmentModel.fromJson(e))
            .toList();
      }
    }
    isLoading.value = false;
  }

  void setStatusFilter(String status) {
    if (selectedStatus.value == status) {
      selectedStatus.value = '';
    } else {
      selectedStatus.value = status;
    }
  }

  Future<void> selectStartDate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      startDate.value = date;
    }
  }

  Future<void> selectEndDate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: endDate.value ?? DateTime.now(),
      firstDate: startDate.value ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      endDate.value = date;
    }
  }

  void clearFilters() {
    selectedStatus.value = '';
    startDate.value = null;
    endDate.value = null;
    getTreatmentHistory(); // Reload without filters
  }

  void setQuickDateRange(String range) {
    final now = DateTime.now();

    switch (range) {
      case 'yesterday':
        final yesterday = now.subtract(const Duration(days: 1));
        startDate.value = yesterday;
        endDate.value = yesterday;
        break;
      case '7days':
        startDate.value = now.subtract(const Duration(days: 7));
        endDate.value = now;
        break;
      case '1month':
        startDate.value = DateTime(now.year, now.month - 1, now.day);
        endDate.value = now;
        break;
      case '3months':
        startDate.value = DateTime(now.year, now.month - 3, now.day);
        endDate.value = now;
        break;
    }
  }

  void applyFilters() {
    String? startDateStr;
    String? endDateStr;

    if (startDate.value != null) {
      startDateStr =
          '${startDate.value!.year}-${startDate.value!.month.toString().padLeft(2, '0')}-${startDate.value!.day.toString().padLeft(2, '0')}';
    }

    if (endDate.value != null) {
      endDateStr =
          '${endDate.value!.year}-${endDate.value!.month.toString().padLeft(2, '0')}-${endDate.value!.day.toString().padLeft(2, '0')}';
    }

    getTreatmentHistory(
      startDate: startDateStr,
      endDate: endDateStr,
      status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
    );
  }

  void toTreatmentHistoryDetail(item) {
    if (item is NurseTreatmentModel) {
      HomeRoute.toTreatmentHistoryDetailScreenNurse(item);
    } else if (item is TreatmentModel) {
      HomeRoute.toTreatmentHistoryDetailScreenCustomer(item);
    } else {
      // Unknown type, show error or do nothing
      print('Unknown item type for detail screen');
    }
  }
}
