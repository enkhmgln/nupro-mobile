import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/auth_route.dart';
import 'package:nuPro/library/shared/client_manager.dart';
import 'package:nuPro/library/utils/constants.dart';
import 'package:nuPro/library/utils/validator.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignInUserController extends IOController {
  final phoneField = IOTextfieldModel(
    label: 'Утасны дугаар',
    validators: [ValidatorType.phone],
    maxLength: 8,
    keyboardType: TextInputType.phone,
  );

  final passField = IOTextfieldModel(
    label: 'Нууц үг',
    isSecure: true,
    validators: [ValidatorType.password],
    keyboardType: TextInputType.visiblePassword,
  );

  final signInButton = IOButtonModel(
    label: 'Нэвтрэх',
    type: IOButtonType.primary,
    size: IOButtonSize.large,
    isEnabled: false,
  ).obs;

  final signUpButton = IOButtonModel(
    label: 'Бүртгүүлэх',
    type: IOButtonType.oulineGray,
    size: IOButtonSize.large,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    phoneField.status.addListener(checkValidation);
    passField.status.addListener(checkValidation);
  }

  void checkValidation() {
    signInButton.update((val) {
      val?.isEnabled = phoneField.isValid && passField.isValid;
    });
  }

  void onTapSignIn() async {
    Get.focusScope?.unfocus();
    startLoading();
    final response = await UserApi().signIn(
      phone: phoneField.value,
      pass: passField.value,
    );
    stopLoading();
    if (response.isSuccess) {
      final token = TokenModel.fromJson(response.data);

      await UserStoreManager.shared.write(kToken, token.toMap());
      print("HelperManager.token.accessToken");
      print(HelperManager.token.accessToken);
      ClientManager.getUserInfo();
    } else {
      showError(text: response.message);
    }
  }

  void onTapSignUp() {
    AuthRoute.toSignUpScreen();
  }

  void onTapForgetPass() {
    AuthRoute.toForgetPass();
  }

  void startLoading() {
    isLoading.value = true;
    signInButton.update((val) {
      val?.isLoading = true;
    });
  }

  void stopLoading() {
    isLoading.value = false;
    signInButton.update((val) {
      val?.isLoading = false;
    });
  }
}
