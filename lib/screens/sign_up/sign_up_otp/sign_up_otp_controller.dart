import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/auth_route.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:get/get.dart';

class SignUpOtpController extends IOController {
  final otp = IOOtpModel(length: 6);
  final timer = IOOtpTimerModel();

  final nextButton = IOButtonModel(
    label: "Үргэжлүүлэх",
    type: IOButtonType.primary,
    size: IOButtonSize.large,
    isEnabled: false,
    isExpanded: true,
  ).obs;
  final SignUpModel model;

  SignUpOtpController({required this.model});

  @override
  void onInit() {
    super.onInit();
    otp.controller.addListener(() {
      nextButton.update((val) {
        val?.isEnabled = otp.isValid;
      });
    });
    timer.startTimer();
    otp.controller.clear();
    otp.focus.requestFocus();
  }

  Future checkOtp() async {
    Get.focusScope?.unfocus();

    nextButton.update((val) {
      val?.isLoading = true;
    });

    final response = await UserApi().checkOtp(
      phoneNumber: model.phone,
      otp: otp.value,
      type: 'register',
    );
    nextButton.update((val) {
      val?.isLoading = false;
    });
    if (response.isSuccess) {
      model.otpToken = response.json['data']['token'].stringValue;
      model.otp = otp.value;
      await AuthRoute.toSignUpUserType(model);
    } else {
      showError(text: response.message);
    }
  }
}
