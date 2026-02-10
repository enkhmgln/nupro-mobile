import 'package:image_picker/image_picker.dart';
import 'package:nuPro/library/client/api/info_api.dart';
import 'package:nuPro/library/components/components.dart';
import 'package:nuPro/library/components/dropdown/io_dropdown_model.dart';
import 'package:nuPro/library/routes/auth_route.dart';
import 'package:nuPro/library/utils/validator.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/gender_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/hospital_info_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/specialization_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/widgets/date_birth_picker.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpInfoController extends IOController {
  final titleText = 'Хувийн мэдээлэл';
  final formKey = GlobalKey<FormState>();
  final userTypeFormKey = GlobalKey<FormState>();
  final SignUpModel model;
  final hospitalsInfo = <HospitalInfoModel>[].obs;
  final specializations = <SpecializationModel>[].obs;
  SignUpInfoController({required this.model});

  final selectedIndex = 0.obs;
  GenderModel? get selectedGender => genders[selectedIndex.value];

  final genders = <GenderModel?>[
    null,
    GenderModel(name: 'Эрэгтэй', icon: 'male', value: 'M'),
    GenderModel(name: "Эмэгтэй", icon: 'female', value: 'F'),
  ];

  void onChange(GenderModel? val) {
    if (val == null) {
      selectedIndex.value = 0;
      return;
    }
    final index = genders.indexWhere((e) => e?.name == val.name);
    if (index != -1) {
      selectedIndex.value = index;
    }
  }

  final uploadedImages = <XFile>[].obs;
  final diplomaFrontImage = Rxn<XFile>();
  final diplomaBackImage = Rxn<XFile>();

  final selectedHospital = Rxn<HospitalInfoModel>();
  final selectedSpecializations = <SpecializationModel>[].obs;

  final surname = IOTextfieldModel(
    label: 'Таны овог',
    validators: [ValidatorType.notEmpty],
  );
  final name = IOTextfieldModel(
    label: 'Таны нэр',
    validators: [ValidatorType.notEmpty],
  );
  final email = IOTextfieldModel(
    label: 'И-мэйл',
    validators: [ValidatorType.email],
    keyboardType: TextInputType.emailAddress,
  );
  final workedYears = IOTextfieldModel(
    label: 'Ажилсан жил',
    validators: [ValidatorType.age],
  );
  final dateBirthField = IOTextfieldModel(
    label: 'Төрсөн өдрөө оруулна уу',
    readOnly: true,
  ).obs;

  final nextButton = IOButtonModel(
    label: 'Үргэлжлүүлэх',
    type: IOButtonType.primary,
    size: IOButtonSize.medium,
    isEnabled: true,
  ).obs;

  final fileUpload = IOButtonModel(
    label: 'Файл оруулах',
    type: IOButtonType.primary,
    size: IOButtonSize.small,
  );

  final dropdownModel = IODropdownModel(
    label: "Эмнэлэг сонгох",
    sheetTitle: "Эмнэлэг сонгох",
    icon: "chevron_down.svg",
  );

  @override
  void onInit() {
    super.onInit();
    getHospitalData();
    getSpecializationData();
  }

  void handleImageUploaded(XFile? image) {
    if (image != null) {
      uploadedImages.value = [image];
    } else {
      uploadedImages.value = [];
    }
  }

  void handleDiplomaFrontUploaded(XFile? image) {
    diplomaFrontImage.value = image;
  }

  void handleDiplomaBackUploaded(XFile? image) {
    diplomaBackImage.value = image;
  }

  void getHospitalData() async {
    isLoading.value = true;
    final response = await InfoApi().getHospitalInfo();
    isLoading.value = false;
    if (response.isSuccess) {
      hospitalsInfo.value = response.data.listValue
          .map((e) => HospitalInfoModel.fromJson(e))
          .toList();
      dropdownModel.setDropdownValue(null);
    } else {
      showError(text: response.message);
    }
  }

  void getSpecializationData() async {
    isLoading.value = true;
    final response = await InfoApi().getSpecializations();
    isLoading.value = false;
    if (response.isSuccess) {
      specializations.value = response.data.listValue
          .map((e) => SpecializationModel.fromJson(e))
          .toList();
    } else {
      showError(text: response.message);
    }
  }

  void onTapDateBirthField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DateBirthPicker(dateBirth: dateBirthField.value.controller.text)
          .show()
          .then((selectedDate) {
        if (selectedDate != null) {
          dateBirthField.value.controller.text = selectedDate;
        }
      });
    });
  }

  void setData() {
    model.lastName = surname.value;
    model.firstName = name.value;
    model.email = email.value;
    model.gender = selectedIndex.value;
    model.dataBirth = dateBirthField.value.value;
    model.sex = selectedGender?.value ?? '';
    model.hospitalId = selectedHospital.value?.id ?? 0;
    model.specializationIds = selectedSpecializations.map((e) => e.id).toList();
    model.uploadedImages = uploadedImages.map((x) => x.path).toList();
    model.diplomaFront = diplomaFrontImage.value?.path ?? '';
    model.diplomaBack = diplomaBackImage.value?.path ?? '';

    model.workedYears = workedYears.value;
    print(model.uploadedImages);
    print(model.uploadedImages);
    print(model.uploadedImages);
  }

  void onTapNext() async {
    Get.focusScope?.unfocus();
    setData();
    nextButton.update((val) => val?.isLoading = true);

    if (surname.value.trim().isEmpty) {
      showError(text: 'Овог оруулна уу');
      nextButton.update((val) => val?.isLoading = false);
      return;
    }

    if (name.value.trim().isEmpty) {
      showError(text: 'Нэр оруулна уу');
      nextButton.update((val) => val?.isLoading = false);
      return;
    }

    if (email.value.trim().isEmpty) {
      showError(text: 'И-мэйл оруулна уу');
      nextButton.update((val) => val?.isLoading = false);
      return;
    }
    if (dateBirthField.value.value.trim().isEmpty) {
      showError(text: 'Төрсөн огноо оруулна уу');
      nextButton.update((val) => val?.isLoading = false);
      return;
    }

    if (selectedGender == null) {
      showError(text: 'Хүйс сонгоно уу');
      nextButton.update((val) => val?.isLoading = false);
      return;
    }
    if (model.userType == 'nurse') {
      final workedYearsText = workedYears.value.trim();

      if (workedYearsText.isEmpty) {
        showError(text: 'Ажилласан жил оруулна уу');
        nextButton.update((val) => val?.isLoading = false);
        return;
      }

      final workedYearsNum = int.tryParse(workedYearsText);
      if (workedYearsNum == null || workedYearsNum < 0 || workedYearsNum > 80) {
        showError(text: 'Зөв ажилласан жил оруулна уу (0-80)');
        nextButton.update((val) => val?.isLoading = false);
        return;
      }
    }

    if (model.userType == 'nurse') {
      if (uploadedImages.isEmpty) {
        showError(text: 'Сувилагчийн гэрчилгээ оруулах шаардлагатай');
        nextButton.update((val) => val?.isLoading = false);
        return;
      }

      if (diplomaFrontImage.value == null) {
        showError(text: 'Дипломын урд тал зураг оруулна уу');
        nextButton.update((val) => val?.isLoading = false);
        return;
      }

      if (diplomaBackImage.value == null) {
        showError(text: 'Дипломын ар тал зураг оруулна уу');
        nextButton.update((val) => val?.isLoading = false);
        return;
      }
    }

    if (model.userType == 'nurse') {
      if (selectedHospital.value == null) {
        showError(text: 'Эмнэлэг сонгоно уу');
        nextButton.update((val) => val?.isLoading = false);
        return;
      }
    }

    if (model.userType == 'nurse') {
      if (selectedSpecializations.isEmpty) {
        showError(text: 'Мэргэжил сонгоно уу');
        nextButton.update((val) => val?.isLoading = false);
        return;
      }
    }

    nextButton.update((val) => val?.isLoading = false);

    AuthRoute.toSignUpPass(model);
  }
}
