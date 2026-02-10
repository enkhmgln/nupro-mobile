import 'package:nuPro/library/components/main/io_alert.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/shared/helper_manager.dart';

class IOController extends GetxController {
  final isInitialLoading = false.obs;
  final isLoading = false.obs;
  final proInfo = HelperManager.profileInfo.obs;

  bool get isLogged => HelperManager.isLogged;

  Future<bool?> showSuccess({
    required String text,
    String? titleText,
    String? buttonText,
    bool dismissable = true,
  }) {
    return IOAlert(
      type: IOAlertType.success,
      titleText: titleText,
      bodyText: text,
      acceptText: buttonText ?? 'Хаах',
      dismissable: dismissable,
    ).show();
  }

  Future<bool?> showError({
    required String text,
    String? titleText,
    String? buttonText,
  }) {
    return IOAlert(
      type: IOAlertType.error,
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
      acceptText: acceptText,
      cancelText: cancelText,
    ).show();
  }
}
