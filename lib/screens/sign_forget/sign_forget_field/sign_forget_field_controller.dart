import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/auth_route.dart';
import 'package:nuPro/library/utils/validator.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/models/sign_reset_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignForgetFieldController extends IOController {
  final model = SignResetModel();

  final phoneField = IOTextfieldModel(
    label: 'Утасны дугаар',
    validators: [ValidatorType.phone],
    maxLength: 8,
    keyboardType: TextInputType.phone,
  );

  final emailField = IOTextfieldModel(
    label: 'И-мэйл',
    validators: [ValidatorType.email],
    keyboardType: TextInputType.emailAddress,
  );

  final nextButton = IOButtonModel(
    label: 'Холбоос илгээх',
    type: IOButtonType.primary,
    size: IOButtonSize.large,
    isEnabled: false,
  ).obs;

  @override
  void onInit() {
    super.onInit();

    phoneField.status.addListener(_updateNextButton);
    emailField.status.addListener(_updateNextButton);
  }

  void _updateNextButton() {
    nextButton.update((val) {
      val?.isEnabled = phoneField.isValid || emailField.isValid;
    });
  }

  Future onTapOtpCheck() async {
    Get.focusScope?.unfocus();
    startLoading();
    final response = await UserApi().sendOtp(
      phone: phoneField.value,
      email: emailField.value,
      type: 'reset_password',
    );
    stopLoading();
    if (response.isSuccess) {
      model.phone = phoneField.value;
      model.email = emailField.value;
      AuthRoute.toForgetOtp(model: model);
    } else {
      showError(text: response.message);
    }
    nextButton.update((val) {
      val?.isLoading = false;
    });
  }

  void startLoading() {
    isLoading.value = true;
    nextButton.update((val) {
      val?.isLoading = true;
    });
  }

  void stopLoading() {
    isLoading.value = false;
    nextButton.update((val) {
      val?.isLoading = false;
    });
  }
}
