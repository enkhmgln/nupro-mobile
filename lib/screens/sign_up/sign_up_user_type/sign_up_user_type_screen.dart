import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/user_type_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_user_type/sign_up_user_type_controller.dart';

class SignUpUserTypeScreen extends GetView<SignUpUserTypeController> {
  const SignUpUserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Хэрэглэгчийн төрөл',
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: IOButtonWidget(
            model: controller.nextButton.value,
            onPressed: controller.onTapNext,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Та хэрэглэгчийн мэдээллээ оруулна уу.',
                    style: IOStyles.body1Bold.copyWith(
                      color: IOColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => DropdownButtonFormField2<UserTypeModel?>(
                    value: controller.selectedUserType,
                    hint: Text(
                      controller.selectedUserType == null ? 'Сонгох' : '',
                      style: IOStyles.body2Medium.copyWith(
                        color: IOColors.textPrimary,
                      ),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: IOColors.backgroundPrimary,
                      contentPadding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: IOColors.backgroundSecondary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: IOColors.backgroundSecondary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: IOColors.brand700),
                      ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: SvgPicture.asset('assets/icons/chevron_down.svg'),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: Get.height / 2,
                      decoration: BoxDecoration(
                        color: IOColors.backgroundPrimary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: controller.userTypes
                        .map(
                          (item) => DropdownMenuItem<UserTypeModel?>(
                            value: item,
                            child: Text(
                              item?.label ?? 'Сонгох',
                              style: IOStyles.body2Medium,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: controller.onChangeUserType,
                    validator: (value) {
                      if (value == null) {
                        return 'Хэрэглэгчийн төрлийг заавал сонгоно уу.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
