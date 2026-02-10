import 'package:get/get.dart';
import 'package:nuPro/library/client/api/payment_api.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/main/io_alert.dart';
import 'package:nuPro/library/components/main/io_super_controller.dart';
import 'package:nuPro/screens/pay/qpay/models/qpay_model.dart';
import 'package:nuPro/screens/pay/qpay/models/qpay_screen_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QpayController extends IOSuperController {
  final QpayScreenModel model;
  final check = IOButtonModel(
    label: 'Төлбөр шалгах',
    type: IOButtonType.primary,
    size: IOButtonSize.medium,
  ).obs;

  QpayController({required this.model});

  @override
  void onResumed() {
    checkPayment();
  }

  Future onCheck(QpayModel item) async {
    try {
      await launchUrlString(
        item.link,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      showWarning(
        text: 'Уг банкний аппликейшнийг суулгана уу',
        acceptText: 'Тийм',
      );
    }
  }

  Future checkPayment() async {
    if (isLoading.value) return;

    isLoading.value = true;
    check.update((val) {
      val?.isLoading = true;
    });

    final response = await PaymentApi().paymentCheck(
      id: model.paymentID,
    );

    isLoading.value = false;
    check.update((val) {
      val?.isLoading = false;
    });

    if (response.isSuccess) {
      final paid = response.data['is_paid'].booleanValue;
      if (paid == true) {
        Get.back(result: true);

        Future.delayed(const Duration(milliseconds: 300), () {
          showSuccess(text: response.message);
        });
      } else {
        showWarning(
          text: response.message,
          acceptText: 'Ойлголоо',
        );
      }
    } else {
      showError(text: response.message);
    }
  }

  void showPaymentRequiredDialog() {
    const IOAlert(
      type: IOAlertType.warning,
      titleText: 'Төлбөр шаардлагатай',
      bodyText:
          'Эмч таны хүсэлтийг зөвшөөрсөн тул үйлчилгээг үргэлжлүүлэхийн тулд төлбөрөө төлөх шаардлагатай. Төлбөрөө төлсний дараа эмчийн байршлыг харах боломжтой болно.',
      acceptText: 'Төлбөр төлөх',
      cancelText: 'Хаах',
    ).show();
  }

  void showFinalWarningDialog() {
    const IOAlert(
      type: IOAlertType.error,
      titleText: 'Анхааруулга',
      bodyText:
          'Төлбөр төлөхгүй бол эмчийн үйлчилгээг авах боломжгүй болно. Та эмчийн хүсэлтийг зөвшөөрсөн тул төлбөрөө төлөх ёстой.',
      acceptText: 'Төлбөр төлөх',
      cancelText: 'Үйлчилгээг цуцлах',
    ).show();
  }

  // Cancel call and exit
  void cancelCallAndExit() {
    const IOAlert(
      type: IOAlertType.warning,
      titleText: 'Үйлчилгээг цуцлах',
      bodyText:
          'Та үйлчилгээг цуцлахдаа итгэлтэй байна уу? Эмчид мэдэгдэх болно.',
      acceptText: 'Тийм, цуцлах',
      cancelText: 'Үгүй',
    ).show().then((result) {
      if (result == true) {
        showWarning(
          text: 'Үйлчилгээг цуцлаж байна. Эмчид мэдэгдэх болно.',
          acceptText: 'Ойлголоо',
        );

        Get.back(result: false);
      }
    });
  }
}
