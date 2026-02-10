import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/auth_route.dart';
import 'package:nuPro/library/utils/validator.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPhoneController extends IOController {
  final model = SignUpModel();

  final emailField = IOTextfieldModel(
    label: 'И-мэйл',
    validators: [ValidatorType.email],
    keyboardType: TextInputType.emailAddress,
  );
  final nextButton = IOButtonModel(
    label: 'Үргэжлүүлэх',
    type: IOButtonType.primary,
    size: IOButtonSize.large,
    isEnabled: false,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    emailField.status.addListener(() {
      nextButton.update((val) {
        val?.isEnabled = emailField.isValid;
      });
    });
  }

  void onTapNext() async {
    Get.focusScope?.unfocus();
    isLoading.value = true;
    nextButton.update((val) {
      val?.isLoading = true;
    });

    final response = await UserApi().sendOtp(
      email: emailField.value,
      type: 'register',
    );
    isLoading.value = false;
    nextButton.update((val) {
      val?.isLoading = false;
    });
    if (response.isSuccess) {
      model.email = emailField.value;
      AuthRoute.toSignUpOtp(model);
    } else {
      showError(text: response.message);
    }
  }
}
