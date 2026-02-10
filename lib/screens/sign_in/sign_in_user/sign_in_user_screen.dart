import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/sign_in/sign_in_user/sign_in_user_controller.dart';
import 'package:flutter/material.dart';

class SignInUserScreen extends StatelessWidget {
  final controller = Get.put(SignInUserController());
  static const routeName = '/SignInUserScreen';
  SignInUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IOScaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/app_logo.png',
                      height: 100,
                      // width: 200,
                    ),
                    Text(
                      'NuPro',
                      style: IOStyles.h2.copyWith(
                        color: IOColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Welcome Section
                Text(
                  'Тавтай морилно уу',
                  textAlign: TextAlign.center,
                  style: IOStyles.h2.copyWith(
                    color: IOColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Мэргэжлийн сувилагчийн үйлчилгээнд нэвтрэх',
                  textAlign: TextAlign.center,
                  style: IOStyles.body1Regular.copyWith(
                    color: IOColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 48),

                IOTextfieldWidget(
                  model: controller.phoneField,
                ),
                const SizedBox(height: 20),
                IOTextfieldWidget(
                  model: controller.passField,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: controller.onTapForgetPass,
                    child: Text(
                      'Нууц үгээ мартсан уу?',
                      style: IOStyles.body1SemiBold.copyWith(
                        color: IOColors.brand500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Primary Button
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [IOColors.brand500, IOColors.brand600],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: IOColors.brand500.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: controller.onTapSignIn,
                      child: Center(
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Нэвтрэх',
                                style: IOStyles.body1SemiBold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Secondary Button
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: IOColors.brand500,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: controller.onTapSignUp,
                      child: Center(
                        child: Text(
                          'Бүртгүүлэх',
                          style: IOStyles.body1SemiBold.copyWith(
                            color: IOColors.brand500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
