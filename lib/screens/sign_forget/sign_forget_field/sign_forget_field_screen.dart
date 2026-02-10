import 'package:nuPro/library/components/components.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignForgetFieldScreen extends GetView<SignForgetFieldController> {
  final ForgetType type;
  const SignForgetFieldScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IOScaffold(
        appBar: IOAppBar(
          titleText: 'Нууц үг сэргээх',
        ),
        body: Stack(
          children: [
            AbsorbPointer(
              absorbing: controller.isLoading.value,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Нууц үг шинэчлэх',
                      style: IOStyles.body1Bold.copyWith(
                        color: IOColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (type == ForgetType.email)
                      Text(
                        'Имэйлээ оруулна уу, бид баталгаажуулах кодыг имэйл рүү илгээх болно',
                        style: IOStyles.body1Medium.copyWith(
                          color: IOColors.textSecondary,
                        ),
                      ),
                    if (type == ForgetType.phone)
                      Text(
                        'Утасны дугаараа оруулна уу, бид баталгаажуулах кодыг имэйл рүү илгээх болно',
                        style: IOStyles.body1Medium.copyWith(
                          color: IOColors.textSecondary,
                        ),
                      ),
                    const SizedBox(height: 26),
                    if (type == ForgetType.email)
                      IOTextfieldWidget(model: controller.emailField),
                    if (type == ForgetType.phone)
                      IOTextfieldWidget(model: controller.phoneField),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IOButtonWidget(
                    model: controller.nextButton.value,
                    onPressed: controller.onTapOtpCheck,
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
