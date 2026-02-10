import 'package:get/get.dart';
import 'package:nuPro/library/client/models/call_detail_info.dart';
import 'package:nuPro/nurse_screen/nurse_call_google_map/nurse_call_google_map_binding.dart';
import 'package:nuPro/nurse_screen/nurse_call_google_map/nurse_call_google_map_screen.dart';
import 'package:nuPro/screens/customer_call_map/customer_call_map_binding.dart';
import 'package:nuPro/screens/customer_call_map/customer_call_map_screen.dart';
import 'package:nuPro/screens/home/home_call_google_map/home_call_google_map_binding.dart';
import 'package:nuPro/screens/home/home_call_google_map/home_call_google_map_screen.dart';
import 'package:nuPro/screens/home/home_controller.dart';
import 'package:nuPro/screens/home/home_questionnaire/home_questionnaire_binding.dart';
import 'package:nuPro/screens/home/home_questionnaire/home_questionnaire_screen.dart';
import 'package:nuPro/screens/home/home_questionnaire/model/health_info_model.dart';
import 'package:nuPro/screens/home/home_to_call_form/home_to_call_form_binding.dart';
import 'package:nuPro/screens/home/home_to_call_form/home_to_call_form_screen.dart';
import 'package:nuPro/screens/home/model/treatment_model.dart';
import 'package:nuPro/screens/pay/qpay/models/qpay_screen_model.dart';
import 'package:nuPro/screens/pay/qpay/qpay_binding.dart';
import 'package:nuPro/screens/pay/qpay/qpay_screen.dart';
import 'package:nuPro/screens/customer_call_map/customer_call_map_rating/customer_call_map_rating_screen.dart';
import 'package:nuPro/screens/customer_call_map/customer_call_map_rating/customer_call_map_rating_controller.dart';
import 'package:nuPro/screens/treatment_history/treaatment_nurse_history_detail/treaatment_nurse_history_detail_binding.dart';
import 'package:nuPro/screens/treatment_history/treaatment_nurse_history_detail/treaatment_nurse_history_detail_screen.dart';
import 'package:nuPro/screens/treatment_history/treatment_history_detail/treatment_history_detail_screen_customer.dart';
import 'package:nuPro/screens/treatment_history/treatment_history_detail/treatment_history_detail_binding_customer.dart';
import 'package:nuPro/screens/home/model/nurse_treatment_model.dart';
import 'package:nuPro/screens/treatment_history/treatment_schedule/treatment_schedule_controller.dart';

class HomeRoute {
  static void toTreatmentHistoryDetailScreenNurse(
      NurseTreatmentModel item) async {
    return Get.to(
      () => TreaatmentNurseHistoryDetailScreen(item: item),
      binding: TreaatmentNurseHistoryDetailBinding(item),
    );
  }

  static void toTreatmentHistoryDetailScreenCustomer(
      TreatmentModel item) async {
    return Get.to(
      () => TreatmentHistoryDetailScreenCustomer(item: item),
      binding: TreatmentHistoryDetailBindingCustomer(item),
    );
  }

  static toQuestionnaire() {
    Get.to(
      () => const HomeQuestionnaireScreen(),
      binding: HomeQuestionnaireBinding(),
    );
  }

  static toHomeCallGoogleMap({
    required HealthInfoModel healthInfo,
    required List<NearestNursesModel> nearestNurses,
  }) {
    Get.to(
      () => const HomeCallGoogleMapScreen(),
      binding: HomeCallGoogleMapBinding(
        healthInfo: healthInfo,
        nearestNurses: nearestNurses,
      ),
    );
  }

  static toCallForm() {
    Get.to(
      () => const HomeToCallFormScreen(),
      binding: HomeToCallFormBinding(),
    );
  }

  static toNurseCallGoogleMap({
    required CallDetailInfoModel callDetailInfoModel,
  }) {
    Get.to(
      () => const NurseCallGoogleMapScreen(),
      binding:
          NurseCallGoogleMapBinding(callDetailInfoModel: callDetailInfoModel),
    );
  }

  static toCustomerCallGoogleMap({
    required CallDetailInfoModel callDetailInfoModel,
  }) {
    Get.to(
      () => const CustomerCallMapScreen(),
      binding: CustomerCallMapBinding(callDetailInfoModel: callDetailInfoModel),
    );
  }

  static Future<bool?>? toQpay({
    required QpayScreenModel model,
  }) {
    return Get.to(
      () => const QpayScreen(),
      binding: QpayBinding(model: model),
    );
  }

  static Future<void> toRating({
    required int callId,
  }) {
    // Үйлчилгээ дууссан үед хэрэглэгчийн төрөл харгалзахгүйгээр үнэлгээний дэлгэц рүү шилжүүлнэ
    return _refreshProfileSilently().then((_) {
      Get.off(
        () => const CustomerCallMapRatingScreen(),
        binding: BindingsBuilder(() {
          Get.delete<CustomerCallMapRatingController>(force: true);
          Get.put<CustomerCallMapRatingController>(
            CustomerCallMapRatingController(),
          );
        }),
        arguments: {'callId': callId},
      );
    });
  }

  static Future<void> _refreshProfileSilently() async {
    try {
      Get.find<TreatmentScheduleController>().getTreatmentHistory();
      Get.find<HomeController>().getTreatment();
      // final response = await UserApi().userInfo();
      // if (response.isSuccess) {
      //   final profile = ProfileModel.fromJson(response.data);
      //   await UserStoreManager.shared.write(kProfileUser, profile.toMap());
      // }
    } catch (_) {}
  }
}
