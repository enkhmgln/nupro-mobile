import 'package:nuPro/library/components/main/io_toast.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/auth_route.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/utils/validator.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/models/sign_reset_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignForgetPassController extends IOController {
  final SignResetModel model;
  SignForgetPassController({
    required this.model,
  });
  final password = IOTextfieldModel(
    label: 'Шинэ нууц үгээ оруулна уу',
    validators: [ValidatorType.password],
    keyboardType: TextInputType.visiblePassword,
    isSecure: true,
  );
  final confirm = IOTextfieldModel(
    label: 'Шинэ нууц үгээ давтан оруулна уу',
    validators: [ValidatorType.password],
    keyboardType: TextInputType.visiblePassword,
    isSecure: true,
  );

  final next = IOButtonModel(
    label: 'Хадгалах',
    type: IOButtonType.primary,
    size: IOButtonSize.medium,
    isEnabled: false,
  ).obs;

  final hasUppercase = false.obs;
  final hasDigits = false.obs;
  final hasLowercase = false.obs;
  final hasMinLength = false.obs;
  final isPasswordMatch = false.obs;

  @override
  void onInit() {
    super.onInit();
    password.controller.addListener(checkValidation);
    confirm.controller.addListener(checkValidation);
  }

  void checkValidation() {
    String passwordText = password.controller.text;
    String confirmText = confirm.controller.text;

    isPasswordMatch.value = passwordText == confirmText;
    hasMinLength.value = passwordText.length >= 8;
    hasUppercase.value = passwordText.contains(RegExp(r'[A-Z]'));
    hasLowercase.value = passwordText.contains(RegExp(r'[a-z]'));
    hasDigits.value = passwordText.contains(RegExp(r'[0-9]'));

    next.update((button) {
      button?.isEnabled = hasMinLength.value &&
          hasUppercase.value &&
          hasLowercase.value &&
          hasDigits.value &&
          isPasswordMatch.value;
    });
  }

  Future resetPassword() async {
    Get.focusScope?.unfocus();
    next.update((val) {
      val?.isLoading = true;
    });
    final response = await UserApi().forgetPassChange(
      newPass: password.value,
      email: model.email,
      token: model.otpToken,
    );
    next.update((val) {
      val?.isLoading = false;
    });
    if (response.isSuccess) {
      AuthRoute.toSignInScreen();
      // IOPages.toHome();
      IOToast(
        text: response.message,
        backgroundColor: IOColors.successPrimary,
        gravity: ToastGravity.TOP,
        time: 2,
      ).show();
    } else {
      showError(text: response.message);
    }
  }
}
