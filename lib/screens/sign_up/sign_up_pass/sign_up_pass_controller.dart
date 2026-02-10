import 'package:nuPro/library/client/client.dart';
import 'package:nuPro/library/components/components.dart';
import 'package:nuPro/library/components/main/io_toast.dart';
import 'package:nuPro/library/shared/client_manager.dart';
import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:nuPro/library/shared/store_manager.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/utils/constants.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignUpPassController extends IOController {
  final SignUpModel model;

  SignUpPassController({
    required this.model,
  });

  final passwordField = IOTextfieldModel(
    label: 'Нууц үг',
    keyboardType: TextInputType.visiblePassword,
    isSecure: true,
  );

  final passwordConfirmField = IOTextfieldModel(
    label: 'Нууц үгээ давтах ',
    keyboardType: TextInputType.visiblePassword,
    isSecure: true,
  );

  final nextButton = IOButtonModel(
    label: 'Хадгалах',
    type: IOButtonType.primary,
    size: IOButtonSize.medium,
    isExpanded: true,
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
    passwordField.controller.addListener(checkValidation);
    passwordConfirmField.controller.addListener(checkValidation);
  }

  void checkValidation() {
    final password = passwordField.value;
    final confirmPassword = passwordConfirmField.value;

    hasMinLength.value = password.length >= 8;
    hasUppercase.value = password.contains(RegExp(r'[A-Z]'));
    hasLowercase.value = password.contains(RegExp(r'[a-z]'));
    hasDigits.value = password.contains(RegExp(r'\d'));

    isPasswordMatch.value = password == confirmPassword;

    nextButton.update((val) {
      val?.isEnabled = password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          hasMinLength.value &&
          hasUppercase.value &&
          hasLowercase.value &&
          hasDigits.value &&
          isPasswordMatch.value;
    });
  }

  Future registerUser() async {
    Get.focusScope?.unfocus();
    isLoading.value = true;
    nextButton.update((val) {
      val?.isLoading = true;
    });

    final formDataMap = {
      'token': model.otpToken.toString(),
      'phone_number': model.phone.toString(),
      'first_name': model.firstName.toString(),
      'last_name': model.lastName.toString(),
      'sex': model.sex.toString(),
      'email': model.email.toString(),
      'user_type': model.userType.toString(),
      'date_of_birth': model.dataBirth.toString(),
      'password': passwordField.value.toString(),
      'fcm_token': HelperManager.fcmToken,
      'hospital_id': model.hospitalId.toString(),
      'nursing_certificate': model.uploadedImages.toString(),
    };

    print("_+_+_++))))$formDataMap");

    final response = await UserApi().register(
      model: model,
      userType: model.userType,
      pass: passwordField.value,
      uploadFile: model.uploadedImages.toString(),
      workedYears: model.workedYears,
    );
    isLoading.value = false;
    nextButton.update((val) {
      val?.isLoading = false;
    });

    if (response.isSuccess) {
      final token = TokenModel.fromJson(response.data);
      print("token+++ $token");
      print("token--- ${token.toMap()}");
      await UserStoreManager.shared.write(kToken, token.toMap());
      print('object${HelperManager.token.accessToken}');
      ClientManager.getUserInfo();

      IOToast(
        text: response.message,
        backgroundColor: IOColors.successPrimary,
        gravity: ToastGravity.TOP,
        time: 2,
      ).show();

      // login(phone: model.phone, pass: passwordField.value);
    } else {
      showError(text: response.message);
    }
  }

  // void login({required String phone, required String pass}) async {
  //   isLoading.value = true;
  //   final response = await UserApi().signIn(
  //     phone: phone,
  //     pass: pass,
  //   );
  //   isLoading.value = false;
  //   if (response.isSuccess) {
  //     final token = TokenModel.fromJson(response.json);
  //     await UserStoreManager.shared.write(kToken, token.toMap());
  //     print('object${HelperManager.token.accessToken}');

  //     Get.find<MainController>().getUserInfo();

  //     IOToast(
  //       text: response.message,
  //       backgroundColor: IOColors.successPrimary,
  //       gravity: ToastGravity.TOP,
  //       time: 2,
  //     ).show();
  //   } else {
  //     showError(text: response.message);
  //   }
  // }
}
