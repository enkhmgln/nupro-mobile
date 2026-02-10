import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/button/io_button_opacity_widget.dart';
import 'package:nuPro/library/components/chip/io_chip.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/components/textfield/io_long_text_field.widget.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/home/home_to_call_form/home_to_call_form_controller.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/gender_model.dart';

class HomeToCallFormScreen extends GetView<HomeToCallFormController> {
  const HomeToCallFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Дуудлага өгөх',
      ),
      bottomNavigationBar: SafeArea(
        child: IOButtonOpacityWidget(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => IOButtonWidget(
                model: controller.toNextButton.value,
                onPressed: controller.onTapHomeCallGoogleMap,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text('Эмчилгээний төрөл',
                style:
                    IOStyles.body1Bold.copyWith(color: IOColors.textPrimary)),
            const SizedBox(height: 8),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: IOChip(
                        title: 'Боолт',
                        selected: controller.treatmentType.value == 'Боолт',
                        onPressed: () {
                          controller.treatmentType.value = 'Боолт';
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IOChip(
                        title: 'Тариа',
                        selected: controller.treatmentType.value == 'Тариа',
                        onPressed: () {
                          controller.treatmentType.value = 'Тариа';
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IOChip(
                        title: 'Дусал',
                        selected: controller.treatmentType.value == 'Дусал',
                        onPressed: () {
                          controller.treatmentType.value = 'Дусал';
                        },
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 16),
            Text('Хугацаат эсэх',
                style:
                    IOStyles.body1Bold.copyWith(color: IOColors.textPrimary)),
            const SizedBox(height: 8),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: IOChip(
                        title: 'Тийм',
                        selected: controller.isTimed.value,
                        onPressed: () {
                          controller.isTimed.value = true;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IOChip(
                        title: 'Үгүй',
                        selected: !controller.isTimed.value,
                        onPressed: () {
                          controller.isTimed.value = false;
                        },
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 16),
            Text('Эмчилгээ авах хүний мэдээлэл',
                style:
                    IOStyles.body1Bold.copyWith(color: IOColors.textPrimary)),
            const SizedBox(height: 8),
            IOTextfieldWidget(
              model: controller.firstName,
            ),
            const SizedBox(height: 8),
            IOTextfieldWidget(
              model: controller.lastName,
            ),
            const SizedBox(height: 8),
            IOTextfieldWidget(
              model: controller.age,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: IOTextFieldLongText(
                model: controller.questionField,
              ),
            ),
            const SizedBox(height: 16),
            Text('Эмчийн бичигт оруулах',
                style:
                    IOStyles.body1Bold.copyWith(color: IOColors.textPrimary)),
            const SizedBox(height: 8),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: IOChip(
                        title: 'Тийм',
                        selected: controller.doctorNote.value,
                        onPressed: () {
                          controller.doctorNote.value = true;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IOChip(
                        title: 'Үгүй',
                        selected: !controller.doctorNote.value,
                        onPressed: () {
                          controller.doctorNote.value = false;
                        },
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 16),
            Text(
              'Хүйс',
              style: IOStyles.body1Bold.copyWith(color: IOColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Form(
              key: controller.formKey,
              child: DropdownButtonFormField2<GenderModel?>(
                value: controller.selectedGender,
                hint: Text(
                  controller.selectedGender == null ? 'Сонгох' : '',
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
                    borderSide:
                        const BorderSide(color: IOColors.backgroundSecondary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: IOColors.backgroundSecondary),
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
                items: controller.genders
                    .map(
                      (item) => DropdownMenuItem<GenderModel?>(
                        value: item,
                        child: item == null
                            ? Text(
                                'Сонгох',
                                style: IOStyles.body2Medium.copyWith(
                                  color: IOColors.textPrimary,
                                ),
                              )
                            : Text(
                                item.name,
                                style: IOStyles.body2Medium,
                              ),
                      ),
                    )
                    .toList(),
                onChanged: controller.onChange,
                validator: (value) {
                  if (value == null) {
                    return 'Хүйсийг заавал сонгоно уу.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Файл оруулах',
                style:
                    IOStyles.body1Bold.copyWith(color: IOColors.textPrimary)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: controller.uploadFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Файл оруулах'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
