import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/utils/validator.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/gender_model.dart';

class HomeToCallFormController extends IOController {
  final formKey = GlobalKey<FormState>();
  final selectedIndex = 0.obs;
  GenderModel? get selectedGender => genders[selectedIndex.value];
  final genders = <GenderModel?>[
    null,
    GenderModel(name: 'Эрэгтэй', icon: 'male', value: 'M'),
    GenderModel(name: "Эмэгтэй", icon: 'female', value: 'F'),
  ];

  final toNextButton = IOButtonModel(
    label: 'Үргэжлүүлэх',
    type: IOButtonType.primary,
    size: IOButtonSize.large,
  ).obs;

  final firstName = IOTextfieldModel(
    label: 'Овог',
    validators: [ValidatorType.notEmpty],
  );

  final lastName = IOTextfieldModel(
    label: 'Нэр',
    validators: [ValidatorType.notEmpty],
  );

  final age = IOTextfieldModel(
    label: 'Нас',
    validators: [ValidatorType.age],
  );

  var questionField = IOTextfieldModel(
    label: 'Анхааруулах мэдээлэл',
    validators: [ValidatorType.notEmpty],
  );

  final treatmentType = 'Буулт'.obs;
  final isTimed = false.obs;
  final doctorNote = true.obs;
  final gender = 'female'.obs;

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

  final notesController = TextEditingController();

  void uploadFile() {
    // Файл оруулах логик
  }

  void onTapHomeCallGoogleMap() {
    // HomeRoute.toHomeCallGoogleMap(nurseInfo: [],healthInfo: );
  }
}
