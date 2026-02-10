import 'package:nuPro/library/components/components.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/library/components/main/io_gesture.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/routes/auth_route.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/sign_forget/sign_forget_email_phone/sign_forget_email_phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SignForgetEmailPhoneScreen
    extends GetView<SignForgetEmailPhoneController> {
  const SignForgetEmailPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Нууц үг сэргээх',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Нууц үгээ мартсан',
                style: IOStyles.h4.copyWith(
                  color: IOColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Баталгаажуулах аргыг сонго, бид баталгаажуулах кодыг илгээх болно',
                style: IOStyles.body1Medium.copyWith(
                  color: IOColors.textSecondary,
                ),
              ),
              const SizedBox(height: 26),
              IOGesture(
                onTap: () => AuthRoute.toForgetField(ForgetType.email),
                child: IOCardBorderWidget(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/mail.svg',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 26),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Имэйл',
                              style: IOStyles.body1Bold.copyWith(
                                color: IOColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Баталгаажуулах кодыг имэйл рүү илгээх',
                              style: IOStyles.caption1Bold.copyWith(
                                color: IOColors.textSecondary,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
