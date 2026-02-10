import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:nuPro/library/components/dropdown/dropdown.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/sign_up_info_controller.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/gender_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/hospital_info_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/widgets/image_upload_widget.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/widgets/multi_select_specialization_widget.dart';

class SignUpInfoScreen extends GetView<SignUpInfoController> {
  const SignUpInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(titleText: controller.titleText),
      bottomNavigationBar: SafeArea(
        child: Obx(() => Padding(
              padding: const EdgeInsets.all(16.0),
              child: IOButtonWidget(
                model: controller.nextButton.value,
                onPressed: controller.onTapNext,
              ),
            )),
      ),
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: AbsorbPointer(
              absorbing: controller.isLoading.value,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Овог',
                        style: IOStyles.caption1SemiBold
                            .copyWith(color: IOColors.textPrimary)),
                    const SizedBox(height: 8),
                    IOTextfieldWidget(model: controller.surname),
                    const SizedBox(height: 16),
                    Text('Нэр',
                        style: IOStyles.caption1SemiBold
                            .copyWith(color: IOColors.textPrimary)),
                    const SizedBox(height: 8),
                    IOTextfieldWidget(model: controller.name),
                    const SizedBox(height: 16),
                    Text('Утасны дугаар',
                        style: IOStyles.caption1SemiBold
                            .copyWith(color: IOColors.textPrimary)),
                    const SizedBox(height: 8),
                    IOTextfieldWidget(model: controller.phone),
                    const SizedBox(height: 16),
                    Text('И-мэйл',
                        style: IOStyles.caption1SemiBold
                            .copyWith(color: IOColors.textPrimary)),
                    const SizedBox(height: 8),
                    IOTextfieldWidget(model: controller.email),
                    const SizedBox(height: 16),
                    if (controller.model.userType == "nurse") ...[
                      Text('Ажилсан жил',
                          style: IOStyles.caption1SemiBold
                              .copyWith(color: IOColors.textPrimary)),
                      const SizedBox(height: 8),
                      IOTextfieldWidget(model: controller.workedYears),
                      const SizedBox(height: 16),
                    ],
                    Text('Та хүйсийн мэдээлэл',
                        style: IOStyles.caption1SemiBold
                            .copyWith(color: IOColors.textPrimary)),
                    const SizedBox(height: 8),
                    Form(
                      key: controller.formKey,
                      child: DropdownButtonFormField2<GenderModel?>(
                        value: controller.selectedGender,
                        hint: Text(
                          controller.selectedGender == null ? 'Сонгох' : '',
                          style: IOStyles.body2Medium
                              .copyWith(color: IOColors.textPrimary),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: IOColors.backgroundPrimary,
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 14, 16, 14),
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
                            borderSide:
                                const BorderSide(color: IOColors.brand700),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon:
                              SvgPicture.asset('assets/icons/chevron_down.svg'),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: Get.height / 2,
                          decoration: BoxDecoration(
                            color: IOColors.backgroundPrimary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        items: controller.genders.map((item) {
                          return DropdownMenuItem<GenderModel?>(
                            value: item,
                            child: item == null
                                ? Text('Сонгох',
                                    style: IOStyles.body2Medium
                                        .copyWith(color: IOColors.textPrimary))
                                : Text(item.name, style: IOStyles.body2Medium),
                          );
                        }).toList(),
                        onChanged: controller.onChange,
                        validator: (value) =>
                            value == null ? 'Хүйсийг заавал сонгоно уу.' : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Төрсөн өдрийн мэдээллийг оруулна уу',
                        style: IOStyles.caption1SemiBold
                            .copyWith(color: IOColors.textPrimary)),
                    const SizedBox(height: 8),
                    Obx(() => IOTextfieldWidget(
                        model: controller.dateBirthField.value,
                        onTap: controller.onTapDateBirthField)),
                    const SizedBox(height: 16),
                    if (controller.model.userType == "nurse") ...[
                      Text('Эмнэлэг сонгох',
                          style: IOStyles.caption1SemiBold
                              .copyWith(color: IOColors.textPrimary)),
                      const SizedBox(height: 8),
                      Obx(() {
                        return controller.isLoading.value
                            ? const IOLoading()
                            : controller.hospitalsInfo.isEmpty
                                ? Text('Эмнэлгийн мэдээлэл олдсонгүй',
                                    style: IOStyles.body2Medium.copyWith(
                                        color: IOColors.textSecondary))
                                : IODropdownWidget<HospitalInfoModel>(
                                    model: controller.dropdownModel,
                                    pickItems: controller.hospitalsInfo
                                        .map((hospital) => IODropdownSheetModel<
                                                HospitalInfoModel>(
                                              name: hospital.name,
                                              value: hospital,
                                            ))
                                        .toList(),
                                    onSelect: (selected) {
                                      final hospital = selected.value;
                                      controller.selectedHospital.value =
                                          hospital;
                                      controller.dropdownModel
                                          .setDropdownValue(selected);
                                    },
                                  );
                      }),
                    ],
                    const SizedBox(height: 16),
                    if (controller.model.userType == "nurse") ...[
                      Text('Мэргэжил сонгох',
                          style: IOStyles.caption1SemiBold
                              .copyWith(color: IOColors.textPrimary)),
                      const SizedBox(height: 8),
                      Obx(() {
                        final selectedList = controller.selectedSpecializations;

                        return controller.isLoading.value
                            ? const IOLoading()
                            : controller.specializations.isEmpty
                                ? Text('Мэргэжлийн мэдээлэл олдсонгүй',
                                    style: IOStyles.body2Medium.copyWith(
                                        color: IOColors.textSecondary))
                                : MultiSelectSpecializationWidget(
                                    key: ValueKey(selectedList.length),
                                    allSpecializations:
                                        controller.specializations,
                                    selectedSpecializations: selectedList,
                                    onChanged: (selected) {
                                      controller.selectedSpecializations
                                          .assignAll(selected);
                                    },
                                  );
                      }),
                      const SizedBox(height: 16),
                    ],
                    if (controller.model.userType == "nurse") ...[
                      Text('Баримт бичгүүд',
                          style: IOStyles.caption1SemiBold
                              .copyWith(color: IOColors.textPrimary)),
                      const SizedBox(height: 12),
                      ImageUploadWidget(
                        label: 'Сувилагчийн гэрчилгээ',
                        onImageAdded: controller.handleImageUploaded,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ImageUploadWidget(
                              label: 'Дипломын урд тал',
                              onImageAdded:
                                  controller.handleDiplomaFrontUploaded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ImageUploadWidget(
                              label: 'Дипломын ар тал',
                              onImageAdded:
                                  controller.handleDiplomaBackUploaded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
