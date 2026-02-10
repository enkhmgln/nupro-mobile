import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/components/main/main.dart';
import 'package:nuPro/library/components/otp/io_otp_timer_view.dart';
import 'package:nuPro/library/components/otp/io_otp_widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_otp/sign_forget_otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignForgetOtpScreen extends GetView<SignForgetOtpController> {
  const SignForgetOtpScreen({super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Кодыг баталгаажуулна уу',
                        style: IOStyles.h3.copyWith(
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
                      Center(child: IOOtpTimerWidget(model: controller.timer)),
                    ],
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
                    model: controller.next.value,
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
