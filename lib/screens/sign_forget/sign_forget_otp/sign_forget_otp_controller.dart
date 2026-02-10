import 'package:nuPro/library/client/api/user_api.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/main/main.dart';
import 'package:nuPro/library/components/otp/io_otp_model.dart';
import 'package:nuPro/library/components/otp/io_otp_timer_model.dart';
import 'package:nuPro/library/routes/routes.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/models/sign_reset_model.dart';
import 'package:get/get.dart';

class SignForgetOtpController extends IOController {
  final SignResetModel model;
  SignForgetOtpController({
    required this.model,
  });
  final otp = IOOtpModel(length: 6);
  final timer = IOOtpTimerModel();

  final next = IOButtonModel(
    label: 'Үргэлжлүүлэх',
    type: IOButtonType.primary,
    size: IOButtonSize.medium,
    isEnabled: true,
    isExpanded: true,
  ).obs;

  Future checkOtp() async {
    Get.focusScope?.unfocus();

    next.update((val) {
      val?.isLoading = true;
    });

    final response = await UserApi().checkOtp(
      phoneNumber: model.phone,
      otp: otp.value,
      type: 'reset_password',
    );

    next.update((val) {
      val?.isLoading = false;
    });

    if (response.isSuccess) {
      model.otpToken = response.json['data']['token'].stringValue;
      model.otp = otp.value;
      await AuthRoute.toOtpForgetCheck(model: model);
    } else {
      showError(text: response.message);
    }
  }
}
