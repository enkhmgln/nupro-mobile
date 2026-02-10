import 'package:nuPro/library/components/components.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/sign_up_phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignUpPhoneScreen extends GetView<SignUpPhoneController> {
  const SignUpPhoneScreen({super.key});

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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Та утасны дугаараа оруулна уу.',
                        style: IOStyles.h6,
                      ),
                      const SizedBox(height: 32),
                      IOTextfieldWidget(
                        model: controller.phoneField,
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
                    model: controller.nextButton.value,
                    onPressed: controller.onTapNext,
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
