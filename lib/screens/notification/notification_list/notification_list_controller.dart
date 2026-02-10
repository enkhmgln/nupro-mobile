// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/client/api/customer_api.dart';
import 'package:nuPro/library/client/models/pagination_model.dart';
import 'package:nuPro/library/components/main/io_alert.dart';
import 'package:nuPro/library/components/main/io_controller.dart';
// import 'package:nuPro/library/components/main/io_toast.dart';
import 'package:nuPro/library/routes/dynamic_route.dart';
import 'package:nuPro/library/components/widgets/incoming_call_modal.dart';
import 'package:nuPro/library/client/models/call_detail_info.dart';
import 'package:nuPro/library/client/api/nurse_api.dart';
import 'package:nuPro/library/routes/home_route.dart';
import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:nuPro/main_controller.dart';
import 'package:nuPro/screens/notification/notification_list/models/notification_list_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationListController extends IOController {
  final refreshController = RefreshController();
  final notificationItems = <NotificationListModel>[].obs;
  final pagination = PaginationModel();
  var unreadCount = 0.obs;
  @override
  var isInitialLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getData(true);
    fetchUnreadCount();
  }

  void onTapItem(NotificationListModel item) async {
    if (!item.isViewed) {
      final response =
          await CustomerApi().getNotificationsMarkViewed(id: item.id);

      if (response.isSuccess) {
        item.isViewed = true;
        notificationItems.refresh();

        unreadCount.value = (unreadCount.value - 1).clamp(0, unreadCount.value);
      } else {
        showError(text: response.message);
      }
    }
    _handleNotificationAction(item);
  }

  void _handleNotificationAction(NotificationListModel item) async {
    final userType = HelperManager.profileInfo.userType;

    if (item.title == 'Шинэ дуудлага') {
      if (userType == 'nurse') {
        // Check for active call before showing modal
        final mainController = Get.find<MainController>();
        if (mainController.currentCallId != null &&
            mainController.currentCallStatus == 'accepted') {
          const IOAlert(
            type: IOAlertType.warning,
            titleText: 'Өмнөх дуудлага идэвхтэй байна',
            bodyText:
                'Та дуудлага дуусгах эсвэл цуцалсны дараа шинэ дуудлагыг хүлээн авч болно.',
            acceptText: 'Ойлголоо',
          ).show();
          return;
        }
        // Fetch call details for full health info
        final detailResponse =
            await NurseApi().bookingsCallsDetailInfo(id: item.actionId);
        if (!detailResponse.isSuccess) {
          const IOAlert(
            type: IOAlertType.warning,
            titleText: 'Дуудлага олдсонгүй',
            bodyText: 'Энэ дуудлага устгагдсан эсвэл олдсонгүй.',
            acceptText: 'Ойлголоо',
          ).show();
          return;
        }
        CallerHealthInfo? healthInfo;
        final callDetail = CallDetailInfoModel.fromJson(detailResponse.data);
        healthInfo = CallerHealthInfo(
          isHealthy: callDetail.customerHealthStatus,
          hasRegularMedication: callDetail.customerHasMedication,
          regularMedicationDetails: callDetail.customerMedicationDetails,
          hasAllergies: callDetail.customerHasAllergies,
          allergyDetails: callDetail.customerAllergyDetails,
          hasDiabetes: callDetail.customerHasDiabetes,
          hasHypertension: callDetail.customerHasHypertension,
          hasEpilepsy: callDetail.customerHasEpilepsy,
          hasHeartDisease: callDetail.customerHasHeartDisease,
          medicalConditionsSummary: callDetail.customerMedicalConditionsSummary,
          additionalNotes: callDetail.customerAdditionalHealthNotes,
        );
        await DynamicRoute.sendCallToNurse(
          callId: item.actionId,
          callerName: item.title.isNotEmpty ? item.title : 'Хэрэглэгч',
          callerPhone: item.url.isNotEmpty ? item.url : '',
          healthInfo: healthInfo,
        );
      }
    } else if (item.title == 'Үйлчилгээ дууслаа' ||
        (item.notifType == 'booking' && item.title.contains('дууслаа')) ||
        (item.notifType == 'feedback' && item.jumpFeedback) ||
        item.title.contains('дууслаа') ||
        item.title.contains('Үйлчилгээ дууслаа')) {
      if (item.actionId > 0) {
        await HomeRoute.toRating(callId: item.actionId);
      } else {
        showError(text: 'Дуудлагын ID олдсонгүй');
      }
    } else if (item.notifType != "Шинэ дуудлага" &&
        item.notifType != "Үйлчилгээ дууслаа") {
      IOAlert(
        type: IOAlertType.success,
        titleText: item.title,
        bodyText: item.body,
        acceptText: 'Хаах',
      ).show();
    }
  }

  Future onRefresh() async {
    pagination.reset();
    getData(false);
  }

  Future onLoad() async {
    getData(false);
  }

  Future getData(bool isInitial) async {
    if (!pagination.shouldFetch) {
      refreshController.refreshCompleted();
      refreshController.loadComplete();
      return;
    }

    if (isInitial) isInitialLoading.value = true;

    final response = await CustomerApi().getNotificationList(
      page: pagination.page,
      limit: pagination.limit,
    );

    if (isInitial) isInitialLoading.value = false;
    refreshController.refreshCompleted();
    refreshController.loadComplete();

    if (response.isSuccess) {
      final items = response.data.listValue
          .map((e) => NotificationListModel.fromJson(e))
          .toList();
      if (pagination.isInitial) {
        notificationItems.value = items;
      } else {
        notificationItems.addAll(items);
      }
      pagination.setValue(
        itemCount: notificationItems.length,
        count: response.data['count'].integerValue,
      );
    } else {
      if (isInitial) {
        Get.back();
      }
      showError(text: response.message);
    }
  }

  Future<void> fetchUnreadCount() async {
    isLoading.value = true;
    final response = await CustomerApi().getNotificationCount();
    isLoading.value = false;

    if (response.isSuccess) {
      unreadCount.value = response.data['unread_count'].integerValue;
    } else {
      showError(text: response.message);
    }
  }
}
