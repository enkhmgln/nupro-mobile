import 'package:nuPro/library/components/main/io_bottom_navigation.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/screens/sign_up/sign_up_pass/sign_up_pass_controller.dart';
import 'package:nuPro/screens/sign_up/sign_up_pass/widgets/sign_up_password_validation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class SignUpPassScreen extends GetView<SignUpPassController> {
  const SignUpPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Бүртгэлийн нууц үг',
      ),
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  IOTextfieldWidget(
                    model: controller.passwordField,
                  ),
                  const SizedBox(height: 16),
                  IOTextfieldWidget(
                    model: controller.passwordConfirmField,
                  ),
                  const SizedBox(height: 16),
                  SignUpPasswordValidationWidget(
                    text: 'Нууц үг 8-с дээш тэмдэгттэй байх',
                    isValid: controller.hasMinLength.value,
                  ),
                  SignUpPasswordValidationWidget(
                    text: 'Том, жижиг үсэг орсон байх',
                    isValid: controller.hasUppercase.value,
                  ),
                  SignUpPasswordValidationWidget(
                    text: 'Тоо орсон байх',
                    isValid: controller.hasDigits.value,
                  ),
                  SignUpPasswordValidationWidget(
                    text: '2 нууц үг таарч байх',
                    isValid: controller.isPasswordMatch.value,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IOBottomNavigationBar(
                child: IOButtonWidget(
                  model: controller.nextButton.value,
                  onPressed: controller.registerUser,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
