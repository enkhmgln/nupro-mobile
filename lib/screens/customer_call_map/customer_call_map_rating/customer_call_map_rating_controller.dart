import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/client/api/rating_api.dart';
import 'package:nuPro/library/components/main/io_alert.dart';
import 'package:nuPro/library/components/main/io_controller.dart';
import 'package:nuPro/library/utils/log.dart';
import 'package:nuPro/main_controller.dart';

class CustomerCallMapRatingController extends IOController {
  final TextEditingController commentController = TextEditingController();
  final RxInt selectedRating = 0.obs;
  @override
  final RxBool isLoading = false.obs;

  late final int callId;

  @override
  void onInit() {
    super.onInit();
    callId = Get.arguments?['callId'] ?? 0;
    Log.success(
        'Rating screen initialized for call ID: $callId', 'RatingController');
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void setRating(int rating) {
    selectedRating.value = rating;
    Log.success('Rating selected: $rating', 'RatingController');
  }

  Future<void> submitRating() async {
    if (selectedRating.value == 0) {
      const IOAlert(
        type: IOAlertType.warning,
        titleText: 'Анхааруулга',
        bodyText: 'Үнэлгээ сонгоно уу',
        acceptText: 'Хаах',
      ).show();
      return;
    }

    if (commentController.text.trim().isEmpty) {
      const IOAlert(
        type: IOAlertType.warning,
        titleText: 'Анхааруулга',
        bodyText: 'Сэтгэгдэл бичнэ үү',
        acceptText: 'Хаах',
      ).show();
      return;
    }

    isLoading.value = true;

    try {
      final response = await RatingApi().submitRating(
        id: callId,
        rating: selectedRating.value,
        comment: commentController.text.trim(),
      );

      if (response.isSuccess) {
        Log.success('Rating submitted successfully', 'RatingController');

        const IOAlert(
          type: IOAlertType.success,
          titleText: 'Амжилттай',
          bodyText: 'Үнэлгээ амжилттай илгээгдлээ. Баярлалаа!',
          acceptText: 'Хаах',
        ).show();
        Get.find<MainController>().getUserInfo();

        await Future.delayed(const Duration(seconds: 1));
        // Get.offAll(() => const NurseHomeScreen());
        Get.until((route) => route.isFirst);
      } else {
        IOAlert(
          type: IOAlertType.error,
          titleText: 'Алдаа',
          bodyText: response.message.isNotEmpty
              ? response.message
              : 'Үнэлгээ илгээхэд алдаа гарлаа',
          acceptText: 'Хаах',
        ).show();
      }
    } catch (e) {
      Log.error('Exception during rating submission: $e', 'RatingController');
      const IOAlert(
        type: IOAlertType.error,
        titleText: 'Алдаа',
        bodyText: 'Үнэлгээ илгээх явцад алдаа гарлаа',
        acceptText: 'Хаах',
      ).show();
    } finally {
      isLoading.value = false;
    }
  }
}
