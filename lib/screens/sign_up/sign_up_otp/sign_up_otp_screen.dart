import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/sign_up/sign_up_otp/sign_up_otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpOtpScreen extends GetView<SignUpOtpController> {
  const SignUpOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Бүртгэл',
      ),
      body: Obx(
        () => Stack(
          children: [
            AbsorbPointer(
              absorbing: controller.isLoading.value,
              child: SizedBox.expand(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Кодыг баталгаажуулна уу',
                          style: IOStyles.h4.copyWith(
                            color: IOColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${controller.model.email} хаяг руу илгээсэн кодыг оруулна уу',
                          style: IOStyles.body1Medium.copyWith(
                            color: IOColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        IOOtpWidget(model: controller.otp),
                        const SizedBox(height: 16),
                        Center(
                            child: IOOtpTimerWidget(model: controller.timer)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IOButtonWidget(
                    model: controller.nextButton.value,
                    onPressed: controller.checkOtp,
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
