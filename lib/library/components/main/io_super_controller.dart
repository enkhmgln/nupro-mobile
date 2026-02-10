import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_alert.dart';

class IOSuperController extends SuperController {
  final isInitialLoading = false.obs;
  final isLoading = false.obs;
  // final count = HelperManager.notifCount.obs;

  Future<bool?> showSuccess({
    required String text,
    String? titleText,
    String? buttonText,
  }) {
    return IOAlert(
      type: IOAlertType.success,
      titleText: titleText,
      bodyText: text,
      acceptText: buttonText ?? 'Хаах',
    ).show();
  }

  Future<bool?> showError({
    required String text,
    String? titleText,
    String? buttonText,
  }) {
    return IOAlert(
      type: IOAlertType.warning,
      titleText: titleText,
      bodyText: text,
      acceptText: buttonText ?? 'Хаах',
    ).show();
  }

  Future<bool?> showWarning({
    required String text,
    String? titleText,
    String? acceptText,
    String? cancelText,
  }) {
    return IOAlert(
      type: IOAlertType.warning,
      titleText: titleText,
      bodyText: text,
      acceptText: acceptText ?? 'Тийм',
      cancelText: cancelText ?? 'Үгүй',
    ).show();
  }

  void onTapNotfication() {
    // AppRoute.toNotificationList()?.then((_) {
    //   ClientManager.getNotificationCount();
    // });
  }

  @override
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}
}
