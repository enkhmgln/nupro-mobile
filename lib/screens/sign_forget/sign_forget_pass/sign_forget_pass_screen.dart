import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/components/main/main.dart';
import 'package:nuPro/library/components/textfield/io_textfield_widget.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_pass/sign_forget_pass_controller.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_pass/widgets/password_validation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SignForgetPassScreen extends GetView<SignForgetPassController> {
  const SignForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Нууц үг сэргээх',
      ),
      body: Obx(
        () => Stack(
          children: [
            AbsorbPointer(
              absorbing: controller.isLoading.value,
              child: SizedBox.expand(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      IOTextfieldWidget(model: controller.password),
                      const SizedBox(height: 16),
                      IOTextfieldWidget(model: controller.confirm),
                      const SizedBox(height: 16),
                      PasswordValidationWidget(
                        text: 'Нууц үг 8-с дээш тэмдэгттэй байх',
                        isValid: controller.hasMinLength.value,
                      ),
                      PasswordValidationWidget(
                        text: 'Том, жижиг үсэг орсон байх',
                        isValid: controller.hasUppercase.value,
                      ),
                      PasswordValidationWidget(
                        text: 'Тоо орсон байх',
                        isValid: controller.hasDigits.value,
                      ),
                      PasswordValidationWidget(
                        text: '2 нууц үг таарч байх',
                        isValid: controller.isPasswordMatch.value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IOButtonWidget(
                    model: controller.next.value,
                    onPressed: controller.resetPassword,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
